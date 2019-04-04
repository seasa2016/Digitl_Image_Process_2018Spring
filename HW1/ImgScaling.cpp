#include<stdio.h>
#include <math.h>      

typedef struct _bmpheader{
    unsigned short dump;				//help alignent	
    unsigned short identifier;      	// 0x0000
    unsigned long filesize;          	// 0x0002
    unsigned long reserved;          	// 0x0006 
	unsigned long bitmap_dataoffset; 	// 0x000A
    unsigned long bitmap_headersize; 	// 0x000E
	long width;             			// 0x0012
    long height;            			// 0x0016
    unsigned short planes;          	// 0x001A
    unsigned short bits_perpixel;   	// 0x001C
    unsigned long compression;       	// 0x001E
    unsigned long bitmap_datasize;   	// 0x0022
    long hresolution;       			// 0x0026
    long vresolution;       			// 0x002A
    unsigned long usedcolors;        	// 0x002E
    unsigned long importantcolors;   	// 0x0032
}bmpheader;

void write_bmp(bmpheader bmpfile,unsigned char ***data,int offset,int depth,int width,int height,FILE *fp)
{
    
    int du=(4-depth*width%4)%4;
    //printf("--%d\n",du);
    unsigned char *dummy;
    dummy=new unsigned char [du];

    fwrite(&bmpfile.identifier,offset,1,fp);
    for(int i=0;i<height;i++)
    {
		for(int j=0;j<width;j++)
        {
            for(int k=0;k<depth;k++)
                fwrite(&data[k][i][j],1,1,fp);
            
            //this can be used to check correct
            /*fwrite(&temp[1][i][j],1,1,fp);
            fwrite(&temp[1][i][j],1,1,fp);
            fwrite(&temp[1][i][j],1,1,fp);
            fwrite(&temp[3][i][j],1,1,fp);
            */
		}
		if(du)
			fwrite(&dummy[0],du,sizeof(unsigned char) ,fp);
	}
}


void read_bmp_data(unsigned char ***data,int depth,int width,int height,FILE *fp)
{
   
    //count the dump data   
    int du=(4-depth*width%4)%4;
    
    unsigned char *dummy;
    dummy=new unsigned char [du];

    for(int i=0;i<height;i++)
    {
        for(int j=0;j<width;j++)		
            for(int k=0;k<depth;k++)
                fread(&data[k][i][j],1,sizeof(unsigned char) ,fp);
        if(du)
            fread(&dummy[0],du,sizeof(unsigned char) ,fp);
    }

    delete[] dummy ;
}

unsigned char bilinear_interpolation(unsigned char a,unsigned char b,unsigned char c,unsigned char d,double d1,double d2)
{
	//unsigned char 
	unsigned char temp_1=a*(1-d1)+b*(d1);
	unsigned char temp_2=c*(1-d1)+d*(d1);

	return (temp_1*(1-d2)+temp_2*d2);
}

void scaling_up(bmpheader &nnew,bmpheader old,unsigned char ***data,unsigned char ****af,double up)
{
	nnew=old;
	nnew.width	=	old.width*up;
	nnew.height	=	old.height*up;
	
	int du=(4-old.bits_perpixel/8*nnew.width )%4;

	nnew.filesize=nnew.height*(nnew.width+du)*old.bits_perpixel/8+nnew.bitmap_dataoffset;
	nnew.bitmap_datasize=nnew.height*(nnew.width+du)*old.bits_perpixel/8;

	unsigned char ***temp;

	(*af)=new unsigned char**[old.bits_perpixel/8];
	
	temp=*af;
	for(int i=0 ; i<(old.bits_perpixel/8) ; i++)
	{
		temp[i]=new unsigned char *[nnew.height];
		for(int j=0 ; j<nnew.height ; j++)
			temp[i][j]=new unsigned char[nnew.width];
	}
	int temp_1,temp_2;
	for(int i=0 ; i<(old.bits_perpixel/8) ; i++)
	{
		for(int j=0 ; j<nnew.height ; j++)
		{
			if(j==nnew.height-1)
			{
				for(int k=0 ; k<nnew.width ; k++)
				{	
					temp_1=floor(j/up);
					temp_2=floor(k/up);
					//printf("%d %d %d\n",i,j,k);
					if(k==nnew.width-1)
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2],data[i][temp_1][temp_2],data[i][temp_1][temp_2],k/up-temp_2,j/up-temp_1);
					else
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],k/up-temp_2,j/up-temp_1);
					
				}
			}
			else
			{
				for(int k=0 ; k<nnew.width ; k++)
				{
					temp_1=floor(j/up);
					temp_2=floor(k/up);
					//printf("%d %d %d\n",i,j,k);
					if(k==nnew.width-1)
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],k/up-temp_2,j/up-temp_1);
					else
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],data[i][temp_1+1][temp_2],data[i][temp_1+1][temp_2+1],k/up-temp_2,j/up-temp_1);
					
				}
			}
		}
	}
}
void scaling_down(bmpheader &nnew,bmpheader old,unsigned char ***data,unsigned char ****af,double down)
{
	nnew=old;
	nnew.width	=	old.width/down;
	nnew.height	=	old.height/down;
	
	int du=(4-old.bits_perpixel/8*nnew.width )%4;

	nnew.filesize=nnew.height*(nnew.width+du)*old.bits_perpixel/8+nnew.bitmap_dataoffset;
	nnew.bitmap_datasize=nnew.height*(nnew.width+du)*old.bits_perpixel/8;

	unsigned char ***temp;
	
	(*af)=new unsigned char**[old.bits_perpixel/8];
	
	temp=*af;
	for(int i=0 ; i<(old.bits_perpixel/8) ; i++)
	{
		temp[i]=new unsigned char *[nnew.height];
		for(int j=0 ; j<nnew.height ; j++)
			temp[i][j]=new unsigned char[nnew.width];
	}
	int temp_1,temp_2;
	for(int i=0 ; i<(old.bits_perpixel/8) ; i++)
	{
		for(int j=0 ; j<nnew.height ; j++)
		{
			if(j==nnew.height-1)
			{
				for(int k=0 ; k<nnew.width ; k++)
				{	
					temp_1=floor(j*down);
					temp_2=floor(k*down);
					//printf("%d %d %d\n",i,j,k);
					if(k==nnew.width-1)
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2],data[i][temp_1][temp_2],data[i][temp_1][temp_2],k*down-temp_2,j*down-temp_1);
					else
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],k*down-temp_2,j*down-temp_1);
					
				}
			}
			else
			{
				for(int k=0 ; k<nnew.width ; k++)
				{
					temp_1=floor(j*down);
					temp_2=floor(k*down);
					//printf("%d %d %d\n",i,j,k);
					if(k==nnew.width-1)
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],k*down-temp_2,j*down-temp_1);
					else
						temp[i][j][k]=bilinear_interpolation(data[i][temp_1][temp_2],data[i][temp_1][temp_2+1],data[i][temp_1+1][temp_2],data[i][temp_1+1][temp_2+1],k*down-temp_2,j*down-temp_1);
				}
			}
		}
	}
}

int main(void)
{
	FILE *fp;
	bmpheader bmpfile;
	char arr1[20],arr2[20];
	unsigned char ***temp;
	unsigned char *header;
	

	for(int ccase=1;ccase<=2;ccase++)
	{
		sprintf(arr1,"input%d.bmp",ccase);
		if((fp=fopen(arr1,"rb"))==0)
		{
			fprintf(stderr,"open file error\n");
			return -1;
		}	
		fread((unsigned char *)&bmpfile.identifier,54,sizeof(unsigned char) ,fp);
		rewind(fp);

		if(bmpfile.bits_perpixel==32)
		{
			temp=new unsigned char **[4];
			for(int i=0;i<4;i++)
			{
				temp[i]=new unsigned char *[bmpfile.height];
				for(int j=0;j<bmpfile.height;j++)
					temp[i][j]=new unsigned char [bmpfile.width];		
			}	
			
			
			//header=new unsigned char[bmpfile.bitmap_dataoffset];
			//rewind(fp);
			//fread(header,bmpfile.bitmap_dataoffset,sizeof(unsigned char) ,fp);
			
			fseek ( fp , bmpfile.bitmap_dataoffset , SEEK_SET );
			read_bmp_data(temp,4,bmpfile.width,bmpfile.height,fp);
			fclose(fp);
			
			bmpheader bmpfile2;
			unsigned char ***t_temp;
			///////////////////////////////
			bmpfile2=bmpfile;
			scaling_up(bmpfile2,bmpfile,temp,&t_temp,1.5);
			if((fp=fopen("output1_up.bmp","wb"))==0)
			{
				fprintf(stderr,"open file error\n");
				return -1;
			}	
			rewind(fp);
			write_bmp(bmpfile2,t_temp,bmpfile2.bitmap_dataoffset,4,bmpfile2.width,bmpfile2.height,fp);
			fclose(fp);
			
			for(int i=0;i<4;i++)
			{
				for(int j=0;j<bmpfile2.height;j++)
					delete[] t_temp[i][j];		
				delete[] t_temp[i];
			}	
			delete[] t_temp;
			////////////////////////////////////////////////////////////////
			bmpfile2=bmpfile;
	
			scaling_down(bmpfile2,bmpfile,temp,&t_temp,1.5);
			if((fp=fopen("output1_down.bmp","wb"))==0)
			{
				fprintf(stderr,"open file error\n");
				return -1;
			}	
			rewind(fp);
			write_bmp(bmpfile2,t_temp,bmpfile2.bitmap_dataoffset,4,bmpfile2.width,bmpfile2.height,fp);
			fclose(fp);
			for(int i=0;i<4;i++)
			{
				for(int j=0;j<bmpfile2.height;j++)
					delete[] t_temp[i][j];		
				delete[] t_temp[i];
			}	
			delete[] t_temp;
		}
		else if(bmpfile.bits_perpixel==24)
		{
			temp=new unsigned char **[4];
			for(int i=0;i<3;i++)
			{
				temp[i]=new unsigned char *[bmpfile.height];
				for(int j=0;j<bmpfile.height;j++)
					temp[i][j]=new unsigned char [bmpfile.width];		
			}	
			
			
			//header=new unsigned char[bmpfile.bitmap_dataoffset];
			//rewind(fp);
			//fread(header,bmpfile.bitmap_dataoffset,sizeof(unsigned char) ,fp);
			
			fseek ( fp , bmpfile.bitmap_dataoffset , SEEK_SET );
			read_bmp_data(temp,3,bmpfile.width,bmpfile.height,fp);
			fclose(fp);
			
			bmpheader bmpfile2;
			unsigned char ***t_temp;
			///////////////////////////////
			bmpfile2=bmpfile;
			scaling_up(bmpfile2,bmpfile,temp,&t_temp,1.5);
			
			if((fp=fopen("output2_up.bmp","wb"))==0)
			{
				fprintf(stderr,"open file error\n");
				return -1;
			}	
			rewind(fp);
			write_bmp(bmpfile2,t_temp,bmpfile2.bitmap_dataoffset,3,bmpfile2.width,bmpfile2.height,fp);
			fclose(fp);
			
			for(int i=0;i<3;i++)
			{
				for(int j=0;j<bmpfile2.height;j++)
					delete[] t_temp[i][j];		
				delete[] t_temp[i];
			}	
			delete[] t_temp;
			////////////////////////////////////////////////////////////////
			bmpfile2=bmpfile;
	
			scaling_down(bmpfile2,bmpfile,temp,&t_temp,1.5);
			if((fp=fopen("output2_down.bmp","wb"))==0)
			{
				fprintf(stderr,"open file error\n");
				return -1;
			}	
			rewind(fp);
			write_bmp(bmpfile2,t_temp,bmpfile2.bitmap_dataoffset,3,bmpfile2.width,bmpfile2.height,fp);
			fclose(fp);
			for(int i=0;i<3;i++)
			{
				for(int j=0;j<bmpfile2.height;j++)
					delete[] t_temp[i][j];		
				delete[] t_temp[i];
			}	
			delete[] t_temp;
		}
		
		for(int i=0;i<3;i++)
		{
			for(int j=0;j<bmpfile.height;j++)
				delete[] temp[i][j];		
			delete[] temp[i];
		}	
		delete[] temp;
	}
	return 0;
}