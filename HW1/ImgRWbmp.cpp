#include<stdio.h>

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

void write_bmp(unsigned char *header,unsigned char ***data,int offset,int depth,int width,int height,FILE *fp)
{
    
    int du=(4-depth*width%4)%4;
    
    unsigned char *dummy;
    dummy=new unsigned char [du];

    fwrite(header,offset,1,fp);
    for(int i=0;i<height;i++)
        for(int j=0;j<width;j++)
        {

            for(int k=0;k<depth;k++)
            {
				//data[k][i][j]=data[k][i][j]/regulization*regulization;
				fwrite(&data[k][i][j],1,1,fp);
			}  
            
			if(du)
                fwrite(&dummy[0],du,sizeof(unsigned char) ,fp);
            //this can be used to check correct
            /*fwrite(&temp[1][i][j],1,1,fp);
            fwrite(&temp[1][i][j],1,1,fp);
            fwrite(&temp[1][i][j],1,1,fp);
            fwrite(&temp[3][i][j],1,1,fp);
            */
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
		/*
		printf("%d\n",bmpfile.identifier);
		printf("%d\n",bmpfile.filesize);
		printf("%d\n",bmpfile.reserved);
		printf("%d\n",bmpfile.bitmap_dataoffset);
		printf("%d\n",bmpfile.bitmap_headersize);
		printf("%d\n",bmpfile.width);
		printf("%d\n",bmpfile.height);
		printf("%d\n",bmpfile.planes);
		printf("%d\n",bmpfile.bits_perpixel);
		printf("%d\n",bmpfile.bitmap_headersize);
		printf("%d\n",bmpfile.compression);
		printf("%d\n",bmpfile.bitmap_datasize);
		printf("%d\n",bmpfile.hresolution);
		printf("%d\n",bmpfile.vresolution);
		printf("%d\n",bmpfile.usedcolors);
		printf("%d\n",bmpfile.importantcolors);
		*/
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
			
			
			header=new unsigned char[bmpfile.bitmap_dataoffset];
			rewind(fp);
			fread(header,bmpfile.bitmap_dataoffset,sizeof(unsigned char) ,fp);
			read_bmp_data(temp,4,bmpfile.width,bmpfile.height,fp);
			fclose(fp);
			

			
			if((fp=fopen("output1.bmp","wb"))==0)
			{
				fprintf(stderr,"open file error\n");
				return -1;
			}	
			rewind(fp);
			write_bmp(header,temp,bmpfile.bitmap_dataoffset,4,bmpfile.width,bmpfile.height,fp);
			fclose(fp);
			
		}
		else if(bmpfile.bits_perpixel==24)
		{
			temp=new unsigned char **[3];
			for(int i=0;i<3;i++)
			{
				temp[i]=new unsigned char *[bmpfile.height];
				for(int j=0;j<bmpfile.height;j++)
					temp[i][j]=new unsigned char [bmpfile.width];		
			}	
			
			header=new unsigned char[bmpfile.bitmap_dataoffset];
			rewind(fp);
			fread(header,bmpfile.bitmap_dataoffset,sizeof(unsigned char) ,fp);
			read_bmp_data(temp,3,bmpfile.width,bmpfile.height,fp);
			fclose(fp);
			
			if((fp=fopen("output2.bmp","wb"))==0)
			{
				fprintf(stderr,"open file error\n");
				return -1;
			}	
			
			rewind(fp);
			write_bmp(header,temp,bmpfile.bitmap_dataoffset,3,bmpfile.width,bmpfile.height,fp);
			fclose(fp);
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