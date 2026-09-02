#include <stdio.h>
//#include <unistd.h>
#include <stdlib.h>
#include <string.h>
//#include <sys/types.h>
#include <sys/stat.h>
//#include <fcntl.h>

#define UNKNOWNFILE 0x00
#define AUDIOFILE   0x01
#define VIDEOFILE   0x02
#define SYSTEMFILE  0X04

#define PACK_H_SIZE 8
#define BUFFSIZE 16384L
// 16kB buffer

double picture_rates [9] = { 0., 24000./1001., 24., 25., 
			     30000./1001., 30., 50., 
			     60000./1001., 60. };


double starttime;
double timecorrect;
typedef unsigned char marker;
typedef unsigned char Byte;
typedef long offset;

char basename[300];
int   chunknumber,chunkcount;
int confirmall;
Byte Buffer[BUFFSIZE];


float Byterate;
offset audioframelength;
int audiolayer;

int EoF;
offset VidSeqStart,VidSeqEnd;
double* startT;
offset* startO;
offset*stopO;
double* stopT;
double Tmax;

int demux;

FILE* InFd,*OutFd;
int splitnum;
int FileType;
offset FileSize;
offset Start,End; //offset of the buffer in file

offset MinimumCut,StuffingQuantum;

double FrameRate;


int CutPart(offset begin,offset end,char* filename);
int Demux(char* name);

int ParseSequence(char* sequence);
int ParseSequenceOffsets(char* sequence);

#ifndef _WIN32
inline 
#endif
int ParseArgs(int ARGC,char** ARGV);


int ParseAudioHdr(offset off);
void  ReadGOPHeader(offset off,double* timestamp);

#ifndef _WIN32
inline
#endif 
int ReadPacketTS(offset* off,double* pts,double* dts);
void ParseVidSeq(offset* off);
int ReadTimeStamp(offset off,double* timestamp);


#ifndef _WIN32
inline
#endif 
void Confirm(char* filename);

#ifndef _WIN32
inline
#endif 
void Offset(double time,offset off);
void TimeToOffsets();
void copy(FILE* InFd,FILE* OutFd,offset from,offset to);
void init(int ARGC,char**ARGV);
void usage();


unsigned short int GetSize(offset off);
#ifndef _WIN32
inline
#endif 
int  FillBuffer(offset off);

#ifndef _WIN32
inline
#endif 
Byte GetByte(offset off);

int FindNext(offset* off, marker mark);
int FindNextMarker(offset* off,marker* mark);

#ifndef _WIN32
inline
#endif 
int EnsureMarker(offset* off,marker* mark);
int FindVideoSeqHeader(offset* off);
int BackwardFindBoundaries(offset from, offset* packetstart, offset* packetend);





int main(int ARGC,char** ARGV){
  offset from,to;
  int i;
  char filename[300];
	printf("\nmpgcut Ver 1.1 - (c)2000 Laurent Alacoque <laureck@users.sourceforge.net>\n\n");
  init(ARGC,ARGV);

  if(FileType==AUDIOFILE){
    for (i= 0; i< chunkcount;i++) {
      if(chunknumber==0){
	sprintf(filename,"%s.mp%d",basename,audiolayer);
	chunknumber++;
      }else{
	sprintf(filename,"%s%d.mp%d",basename,chunknumber++,audiolayer);
      }
      printf("[%1.2fs %1.2fs] -> ",startT[i],stopT[i]);
      Confirm(filename);
      printf("%s ",filename);
      fflush(stdout);

      OutFd = fopen(filename,"wb");
      if (OutFd ==0) {
	perror("Unable to open output file ");
	continue;
      }
      from= ((offset)(startT[i]*Byterate)/audioframelength)*audioframelength;
      to= ((offset)(stopT[i]*Byterate)/audioframelength)*audioframelength;
      copy(InFd,OutFd,from,to);
      fclose(OutFd);
    }
    for (i=0; i<splitnum;i++){
      sprintf(filename,"%s%d-%d.mp%d",basename,i+1,splitnum,audiolayer);
      printf("Part %d/%d -> ",i+1,splitnum);
      Confirm(filename);
      printf("%s ",filename);
      fflush(stdout);
      
      OutFd = fopen(filename,"wb");
      if (OutFd ==0) {
	perror("Unable to open output file ");
	continue;
      }
      from= ((FileSize*i)/(splitnum*audioframelength))*audioframelength;
      to= ((FileSize*(i+1))/(splitnum*audioframelength))*audioframelength;
      copy(InFd,OutFd,from,to);
      fclose(OutFd);
    }
  }else{ //system or video file
    if(chunkcount >0) TimeToOffsets();
    for (i= 0; i< chunkcount;i++) {
      if(chunknumber==0){
	sprintf(filename,"%s.mpg",basename);
	chunknumber++;
      }else{
	sprintf(filename,"%s%d.mpg",basename,chunknumber++);
      }
      if((startT[i]==-1)&&(stopT[i]==-1)){
	printf("{%ld %ld} -> ",startO[i],stopO[i]);
      }
      CutPart(startO[i],stopO[i],filename);
    }
    for (i=0; i<splitnum;i++){
      sprintf(filename,"%s%d-%d.mpg",basename,i+1,splitnum);
      printf("Part %d/%d -> ",i+1,splitnum);
      CutPart(FileSize*i/splitnum,FileSize*(i+1)/splitnum,filename);
    }
  }
  if(demux) Demux(basename);
  if(InFd != 0) fclose(InFd);    

  return 0;
}

#ifndef _WIN32
inline
#endif 
int ParseArgs(int ARGC,char** ARGV){
  int argcount=1;
  int okfl=0;
  int fileok=0;
  long bidule;
  char* truc;
  for (;argcount<ARGC;argcount++){
    if(ARGV[argcount][0]=='-'){
      switch (ARGV[argcount][1]){
      case 'd':
	demux=1;
	okfl=1;
	break;
      case 'f':
	confirmall=0;
	break;
      case 'n': 
	bidule=strtol(&(ARGV[argcount][2]),&truc,10);
	if (truc==&(ARGV[argcount][2])){
	  bidule=strtol(ARGV[argcount+1],&truc,10);
	  if (truc==ARGV[argcount+1]) usage();
	  else {
	    //  printf("split file in %ld\n",bidule);
	    argcount++; okfl=1; splitnum=bidule;
	    break;}

	}
	//	printf("split file in %ld\n",bidule);
	splitnum=bidule;
	okfl=1;
	break;
      case 'b':
	//next arg must be filename base. check if it's not a "-";
	if (ARGV[argcount+1][0]=='-') usage();
	else{
	  sprintf(basename,"%s",ARGV[argcount+1]);
	  argcount++;
	}
	//	printf("Basename : %s\n", basename);  
	
	break;
      default :
	usage();
      }
    }
    else if (ARGV[argcount][0]=='[') {
      ParseSequence(ARGV[argcount]);
      okfl=1;
    }
    else if (ARGV[argcount][0]=='{'){
      ParseSequenceOffsets(ARGV[argcount]);
      okfl=1;

    }
    else{
      if(fileok) usage();
      fileok=1;
      // this arg is input filename
      //      printf("input mpeg filename %s\n",ARGV[argcount]);
      InFd=fopen(ARGV[argcount],"rb");
      if (InFd ==0) {
	perror("Unable to open input file ");
	usage();
      }
      
    }
  }
  if((okfl==1)&&(fileok==1))
    return 1;
  else usage();
  return(0);

}

int ParseSequence(char* sequence){
  char* ptr=sequence+1;
  double start,stop;
  char *begin,*end;
  int number;
  float m1,m2,m3;
    
  begin=strstr(ptr,"-");
  if(begin==NULL) usage();
  end=strstr(begin,"]");
  if(end==NULL) usage();
  number=sscanf(ptr,"%f:%f:%f",&m1,&m2,&m3);
  switch(number){
  case 0: usage();
  case 1: start=m1; break;
  case 2: start=m2+m1*60; break;
  case 3: start=m3+m2*60*m1*3600; break;
  default: usage();
  }
  number=sscanf(begin+1,"%f:%f:%f",&m1,&m2,&m3);
  switch(number){
  case 0: usage();
  case 1: stop=m1; break;
  case 2: stop=m2+m1*60; break;
  case 3: stop=m3+m2*60*m1*3600;break;
  default: usage();
  }

  if ((start<0)||(start>stop)) usage();
  startT[chunkcount]=start;
  startO[chunkcount]=-1;
  stopT[chunkcount]=stop;
  stopO[chunkcount]=-1;
  chunkcount++;
  //  printf("Cut between %1.2f s and %1.2f s\n",start,stop);
  return 0;

}
int ParseSequenceOffsets(char* sequence){
  char* ptr=sequence;
  offset start,stop;
  int number;
  number=sscanf(ptr,"{%ld-%ld}",&start,&stop);
  if (number !=2) usage();
  if ((start<0)||(start>stop)) usage();
  startT[chunkcount]=-1;
  startO[chunkcount]=start;
  stopT[chunkcount]=-1;
  stopO[chunkcount]=stop;
  chunkcount++;
  //  printf("Cut between %1.2f s and %1.2f s\n",start,stop);
  return 0;

}

void init(int ARGC,char** ARGV){
  int i;
  marker mymark;
  offset myoff=0;
  demux=0;
  confirmall=1;
  startT=(double*)(calloc(ARGC-1,sizeof(double)));
  stopO=(offset*)(calloc(ARGC-1,sizeof(offset)));
  stopT=(double*)(calloc(ARGC-1,sizeof(double)));
  startO=(offset*)(calloc(ARGC-1,sizeof(offset)));
  chunkcount=0;
  splitnum=0;
  EoF=0;
  timecorrect=0;
  MinimumCut=-1;
  VidSeqStart=VidSeqEnd=-1;
  sprintf(basename,"chunk");
  chunknumber=0;
  if (!ParseArgs(ARGC,ARGV)) usage();
  Tmax=0;
  for(i=0;i<chunkcount;i++){
    Tmax=(Tmax < (startT[i]))?startT[i]:Tmax;
    Tmax=(Tmax<(stopT[i]))?stopT[i]:Tmax;
  }
  fseek(InFd,0L,SEEK_END);
  FileSize=ftell(InFd);
  FillBuffer(0);
  //try to find file type (mpeg audio, video, system)
  if (EnsureMarker(&myoff,&mymark)){
    // good! first 4 bytes in file are an mpeg start code
    if (mymark == 0xba) // system header
      { FileType=SYSTEMFILE;
      printf("yahaaaa this is a system mpeg file\n"); 
      //try to find valuable info
      if(!FindVideoSeqHeader(&myoff)){
	//didnt find video seq header in whole file
	printf("Sorry dude didn't find a mpeg vid header\n");
	exit(1);
      }
      // vid seq header found, PARSE IT !
	
      ParseVidSeq(&myoff);
      return ;
      }
    else if (mymark==0xb3){//video sequence header
      { FileType=VIDEOFILE;
      ParseVidSeq(&myoff);
      printf("mpeg video only file\n");
      //	exit(0);
      return ;
      }
    }
    else {
      printf("mmm unknown mpeg marker at begining... I'd better exit\n");
      exit(1);
    }
  }
  
  // file doesn't begin with a start code... maybe audio?
  if((GetByte(0)==0xff)&&((GetByte(1)&0xf0)==0xf0))
    { FileType=AUDIOFILE;
    if(ParseAudioHdr(1))
      printf("Mpeg audio file\n");
    return;
    }
  //file doesn't begin with a start code nor audio sync
  // well could *search* for something... exit for now
  FileType=UNKNOWNFILE;
  exit(1);
}

void usage(){
  printf("usage : mpegcut  [-n count] [-b basename] [-f] [-d] \n                 [ [start-end] {start-end} ...] INFILE\n");
  printf("OPTIONS:\n -n count cuts the mpeg file in count parts\n -b basename every chunk will be named basenameXXX.mpg\n");
  printf(" [start-end] chunk start and end definition in secondes\n             or with the HH:MM:SS.mm format\n");
  printf(" {start-end} chunk start and end definition in file offsets\n");
  printf(" -d  demultiplexes INFILE (i.e. separates audio from video)\n");
  printf(" -f  don't ask for confirmation before overwriting\n");
  printf("\nEXAMPLES:\n mpgcut [4:45.3-6:30.4] myfile.mpg\n   cuts myfile.mpg from 4mn 45.3s to 6mn 30.4s\n"); 
  printf(" mpgcut {2345-567455} myfile.mpg\n   cuts myfile.mpg between offsets 2345 and 567455\n");
  printf(" mpgcut -n 5 myfile.mpg\n   cuts myfile.mpg in five chunks\n"); 
  printf("\n more info on mpgcut can be found on http://mpgcut.sourceforge.net\n");
  exit(1);
}

#ifndef _WIN32
inline
#endif 
int FillBuffer(offset off){
  int readsize;
  fseek(InFd,off,SEEK_SET);
  readsize=fread(Buffer,1,BUFFSIZE,InFd);

  if (readsize <=0) { //on ne peut pas lire
    //    Start=End=-1;
    clearerr(InFd);
    return 0;
  }
  Start=off; End=Start+readsize;
  return 1;
}

int FindNextMarker(offset* off,marker* mark){
  offset myoffset=*off;
  while(myoffset<FileSize-3){
    // is there enough ?

    if ((myoffset-Start) > (BUFFSIZE-16)) FillBuffer(myoffset);
    if ( (GetByte(myoffset+0) == 0x00) &&
	 (GetByte(myoffset+1) == 0x00) &&
	 (GetByte(myoffset+2) == 0x01)){
      *off=myoffset+4;
      *mark=GetByte(myoffset+3);
      //    printf("Trouvé marqueur %02x offset %ld [%04lx]\n",
      //   GetByte(myoffset+3),myoffset,myoffset);
      return 1;
      
    }
    myoffset++;
  }
  //  printf("Fin du fichier atteinte :/ \n");
  EoF=1;
  return 0;
  
}
int FindNext(offset* off,marker mark){
  offset myoffset=*off;
  while(myoffset<FileSize-3){
    // is there enough ?

    if ((myoffset-Start) > (BUFFSIZE-16)) FillBuffer(myoffset);
    if ( (GetByte(myoffset+0) == 0x00) &&
	 (GetByte(myoffset+1) == 0x00) &&
	 (GetByte(myoffset+2) == 0x01) &&
	 (GetByte(myoffset+3) == mark)){
      *off=myoffset+4;
      //    printf("Trouvé marqueur %02x offset %ld [%04lx]\n",
      //   GetByte(myoffset+3),myoffset,myoffset);
      return 1;
      
    }
    myoffset++;
  }
  //  printf("Fin du fichier atteinte :/ \n");
  EoF=1;
  return 0;

}

#ifndef _WIN32
inline
#endif 
Byte GetByte(offset off){
  if ((off>=Start)&&(off<End)) return Buffer[off-Start];
  else {
    if(FillBuffer(off))
      return Buffer[off-Start];
    else // unrecoverable error
      {
	if (off >=FileSize){
	  printf("(bug) you shouldn't read this" 
		 "\n asked me to read at offset %ld" 
		 " ,File size %ld\n",off,FileSize);}
	else{
	  //really weird!
	  printf("(bug) fread error while reading file offset %ld (Filesize %ld)\nexiting...",
		 off,FileSize);
	  exit(1);
	}
	return 0xff;
      }
  }
}
#ifndef _WIN32
inline
#endif 
int EnsureMarker(offset* off,marker* mark){
  if ( (GetByte((*off)+0) == 0x00) &&
       (GetByte((*off)+1) == 0x00) &&
       (GetByte((*off)+2) == 0x01)){
    *mark=GetByte((*off)+3);
    *off=(*off)+4;
    return 1;
  }else{
    return 0;
  }    

}
int FindVideoSeqHeader(offset* off){
  //we're parsing a system file... 
  //ugly way : find 00 00 01 B3
  //smart way : parse PACK headers and packets type
  //            try to find a video seq in video packet
  // let's be ugly :>
  return FindNext(off,0xb3);
}

unsigned short int GetSize(offset off){
  return GetByte(off)*256 +GetByte(off+1);
}
void ParseVidSeq(offset* off){
  int horsize,versize;
  int pictrate;
  marker mymark;
  offset saveoff=*off;
  offset pstart,pend;
  double pts,dts;
  starttime=-1;
  VidSeqStart=(*off)-4;
  horsize=(GetSize(*off)>>4);
  versize=(GetSize((*off)+1)&0x0fff);
  printf("mpeg video is %d x %d\n",horsize,versize);
  pictrate=(GetByte((*off)+3)&0x0f);
  if (pictrate>8) {
    FrameRate=0;
    printf("invalid picture rate... strange\n");
  }
  else {
    FrameRate=picture_rates[pictrate];
    printf("picture rate is %f fps\n",
	   picture_rates[pictrate]);
  }
  //we'd have to really parse the remaining but too lazy 
  // let's just find next marker which should be a GOP
  *off+=6; //at least

  while (1==1){
    if(FindNextMarker(off,&mymark)&&(mymark==0xb8)){
      //we have it! aren't we too far?
      if(((*off) - saveoff)<150 ){
	//yeah Y 150? -> because (hint 2 matrix)
	if(FileType==VIDEOFILE) ReadGOPHeader(*off,&starttime); //get time written in first GOP
	else{
	  BackwardFindBoundaries(*off,&pstart,&pend);
	  if (GetByte(pstart+3)==0xe0) {
	    // that's a video packet ok
	    offset pstart2=pstart+6;
	    ReadPacketTS(&pstart2,&pts,&dts);
	    if(dts!=-1) starttime=dts;
	    else starttime=pts;
	  }
	}
	//	printf("Video Sequence header seems to end at [0x%lx]\n",
	//     (*off)-4);
	VidSeqEnd=(*off-4);
	if (FileType==SYSTEMFILE){
	  MinimumCut=VidSeqStart;
	  while(1){
	    MinimumCut--;
	    if (MinimumCut<=0) {
	      printf("lost, exiting\n");
	      exit(1);
	    }
	    if (EnsureMarker(&MinimumCut,&mymark))
	      {
		if (mymark==0xba){
		  MinimumCut-=4;break;
		}
		else {MinimumCut -=4;}
	      }
	    
	  }
	}
	else
	  MinimumCut=(*off)-4;
	break;
      }
      else {
	//mmm it seems we're lost let's givit a try
	printf("Video Sequence header seems to end at [0x%lx] but we might be lost :/\n",
	       (*off)-4);
	VidSeqEnd=(*off-4);
	if (FileType==SYSTEMFILE){
	  MinimumCut=VidSeqStart;
	  while(1){
	    MinimumCut--;
	    if (MinimumCut<=0) {
	      printf("lost, exiting\n");
	      exit(1);
	    }
	    if (EnsureMarker(&MinimumCut,&mymark))
	      {
		if (mymark==0xba){
		  MinimumCut-=4;break;
		}
		else {MinimumCut -=4;}
	      }
	    
	  }
	}
	else
	  MinimumCut=(*off)-4;
	break;
      }
    }
    if(EoF==1){ // end of file reached :/
      printf("couldn't find first GOP! let's die\n");
      exit(1);
    }
    //printf("Strange I just passed a 00 00 01 %02x sequence...\n",
    //    mymark);
}
}


int BackwardFindBoundaries(offset from, offset* packetstart, offset* packetend){
//find the packet boundaries in which "from" is
offset myfrom=from;
marker mymark;
//TODO : heavy disk load when buffer's not good. FillBuffer starts @0
if ((myfrom <0)||(myfrom >FileSize)) return(0);
for(;myfrom>=0;myfrom--){
if (EnsureMarker(&myfrom,&mymark)){
//a marker was found at offset from -4
if((mymark==0xe0)){
//video packet
*packetstart=myfrom-4;
*packetend=myfrom+GetSize(myfrom)+2;
if((from<*packetstart)||(from>*packetend)) 
     // found packet boundaries but
     // from wasn't inside...
     return 0; 
     else return 1;
      }
      else myfrom -=4;
    }

  }
  return 0;
}
void copy(FILE* InFd,FILE* OutFd,offset from,offset to){
  if ((InFd)&&(OutFd)){
    //printf("Copying from [%lx] to [%lx] (%ld)\n",from,to,to-from);
    long rsize=0;
    long size=0;
    FillBuffer(from);
    fseek(OutFd,0L,SEEK_END);
    while(rsize < to -from){
      rsize+=BUFFSIZE;
      if (rsize >( to-from)) size = (to-from)%BUFFSIZE;
      else size=BUFFSIZE;
      fwrite(Buffer,1,size,OutFd);
      FillBuffer(from+rsize);
    }
  }
    return ;
}


void ReadGOPHeader(offset off, double* timestamp){
  Byte hour,min,sec,count;
  *timestamp=0;
  //  printf(" [%02x %02x %02x %02x]\n",
  // GetByte(off),GetByte(off+1),GetByte(off+2),GetByte(off+3));
  //  printf("     Drop frame marker: ");
  //  if (GetByte(off)&0x80) printf("1\n");
  //  else printf("0\n");
  hour=GetByte(off);
  hour &= !0x80; //clears drop frame marker bit
  hour >>=2;      //hour :bits[6-2]
  *timestamp+=hour*3600;
  //  printf("     hour : %d\n",hour);
  min=GetByte(off+1);
  min >>=4;
  hour=GetByte(off);
  hour <<= 6 ;
  hour >>=2;
  min ^= hour;
  *timestamp+=min*60;
  //  printf("     minutes : %d\n",min);
  min=GetByte(off+1);
  min <<= 5;
  min >>= 2;
  sec=GetByte(off+2);
  sec >>=5;
  sec ^= min;
  *timestamp+=sec;
  //  printf("     secondes : %d\n",sec);
  count=GetByte(off+2);
  count <<=3;
  count >>=2;
  sec=GetByte(off+3);
  if (sec & 0x80) count |= 0x01;
  *timestamp += count / FrameRate;
  //  printf("     count : %d\n",count);
  //  printf ("     Closed GOP flag : ");
  //  if (sec & 0x40) printf("1\n");
  //  else printf("O\n");
  //  printf("     Broken link flag : ");
  //  if (sec & 0x20) printf("1\n");
  //  else printf("O\n");

  

}

int CutPart(offset begin, offset end, char* filename){
  offset myoff=0;
  //  double begin,end;
  //  double Goptime=0;
  //  marker mymark;
  double trash;
  offset mybeg,myend;
  offset packetstart,packetend;
  offset from,GOPbeg,to,GopToEOP;
  offset packetheaderlength;
  offset sizeofnewpacket;
  Byte highsize,lowsize;
  if((begin >=FileSize)||(begin<0)) {
    printf(" beyond end of file skiping\n");
    return 0;
  }
  //write mpeg file headers
  Confirm(filename);
  printf("%s ",filename);
  fflush(stdout);

  mybeg=begin;
  myend=end;
  from=GOPbeg=to=GopToEOP=-1;
  OutFd = fopen(filename,"wb");
  if (OutFd ==0) {
    perror("Unable to open output file ");
    return 0;
  }
  if((MinimumCut >=0)){
    copy(InFd,OutFd,0,MinimumCut);
    fflush(OutFd);
    //    stuff(OutFd,StuffingQuantum);
    myoff=MinimumCut;
  }
  else{
    return 0;
  }

  //finds first pack including gop

  if(!FindNext(&mybeg,0xb8)){
    //couldn't find anything after begining
    return 0;
  }
  else {
    // I have a gop!
    if (FileType==VIDEOFILE) { from=mybeg-4; }
    else{

      GOPbeg=mybeg-4;
      if(!BackwardFindBoundaries(mybeg,&packetstart,&packetend)){
	printf("Error couldn't find video packet in file\n");
	return 0;
      }
      from=packetstart-12; //till PACK start
      //    stufbeg=(myoff-4)-(packetstart+4+5);
      GopToEOP=packetend-GOPbeg;
    }
  }
  //we have the begining

  if(!FindNext(&myend,0xb8)){
    //couldn't find anything after begining
    to=FileSize;
    if(FileType==VIDEOFILE){copy(InFd,OutFd,from,to); fclose(OutFd); printf("\n"); return 1;}
  }
  else {
    // I have a gop!
    if (FileType==VIDEOFILE) { to=myend-4; copy(InFd,OutFd,from,to);fclose(OutFd);printf("\n"); return 1;}
    else{
      to=myend-4;
    }
  }

  //okay here we are.
  // we already copied the mandatory headers i.e. until first video pack
  // what we have to do here is copy the pack and pack header
  // compute the new packet length
  // write it along with video packet header
  // write the Video Sequence header
  // write the video sequence starting from GOPbeg, til to
  // then we're done.

  //computes the packet header length by parsing it and then getting the modified offset
  //from is the PACK start from +12 +4 +2 has to be after the video packet length field.
  packetheaderlength=from+12+4+2;
  ReadPacketTS(&packetheaderlength,&trash,&trash);
  packetheaderlength-=(from+12+4+2);




  //compute the new packet size
  // size of added VideoSequence(i.e. 00 00 01 b3 -> til GOP)
  // + GOP to end of packet
  // + packet header length





  sizeofnewpacket =VidSeqEnd-VidSeqStart+GopToEOP+packetheaderlength;
  highsize=(Byte)(sizeofnewpacket >> 8);
  lowsize=(Byte)(sizeofnewpacket & 0xFF);
    


  copy(InFd,OutFd,from,from+12+4); 
  fwrite(&highsize,1,1,OutFd);
  fwrite(&lowsize,1,1,OutFd);
  fflush(OutFd);
  copy(InFd,OutFd,(from+12+4+2),(from+12+4+2+packetheaderlength)); 
  fflush(OutFd);
  copy(InFd,OutFd,VidSeqStart,VidSeqEnd);
  fflush(OutFd);
  copy(InFd,OutFd,GOPbeg,to);
  fclose(OutFd);
  printf("\n");
  return(1);

}


#ifndef _WIN32
inline
#endif 
int ReadPacketTS(offset* off,double* pts,double* dts){
  //just after the packet start code. and the length field
  offset myoff=*off;
  Byte mybyte;
  //get rid of stuffing bytes
  mybyte=GetByte(myoff);
  while(mybyte & 0x80){
    //    printf("sb ");
    //this has to be a stuffing byte
    mybyte=GetByte(++myoff);
  }
  //  printf("->%x ",mybyte);
  //here mybyte is the first valid byte
  if((mybyte>>6)==0x01){
    //std buffer scale stuff... let's skip it
    myoff+=2;
    mybyte=GetByte(myoff);
    //  printf("std buff, skip ->%x ",mybyte);
  }
  if((mybyte>>4)==0x02){
    // dts Time stamp
    //  printf(" PTS\n");
    ReadTimeStamp(myoff,pts);
    *dts=-1;
    *off=myoff+5;
    return 1;
  }
  else if ((mybyte>>4)==0x03){
    //    printf(" PTS & DTS\n");
  //both pts and dts time stamps
    ReadTimeStamp(myoff,pts);
    myoff+=5;
    ReadTimeStamp(myoff,dts);
    *off=myoff+5;
    return 1;

  }
  else {
    // curious byte, skip it
    //    printf("unknown\n");
    myoff++;
  }
  *dts=*pts=-1;
  *off=myoff;
  return 0;
}

int ReadTimeStamp(offset off,double* timestamp){
  Byte hiBit;
  unsigned long low4Bytes;
  hiBit= (GetByte(off)>>3)&0x01;
  low4Bytes = ((GetByte(off) >> 1)&0x03)<<30;
  low4Bytes |= GetByte(off+1)<< 22;
  low4Bytes |= (GetByte(off+2)>>1)<<15;
  low4Bytes |= GetByte(off+3) << 7;
  low4Bytes |= GetByte(off+4) >> 1;
#define FLOAT_0x10000 (double)((unsigned long)1 << 16)
#define STD_SYSTEM_CLOCK_FREQ (unsigned long)90000
  if (hiBit != 0 && hiBit != 1) {
    *timestamp = -1;
    return 0;
  }
  *timestamp 
    = (double)hiBit*FLOAT_0x10000*FLOAT_0x10000 + (double)low4Bytes;
  *timestamp /= (double)STD_SYSTEM_CLOCK_FREQ;
  return 1;
}

void TimeToOffsets(){
  int i;
  double pts,dts;
  double timesave=0;
  offset myoff=0;
  offset skipto=0;
  int counter=0;
  if(FileType==SYSTEMFILE){
    while(FindNext(&myoff,0xe0)&&((timesave+timecorrect-starttime)<Tmax)){
      skipto=myoff+GetSize(myoff);
      myoff+=2; //skip size
      ReadPacketTS(&myoff,&pts,&dts);
      if(pts!=-1){ 
	if (dts!=-1)
	  {if ((dts<timesave)||(dts>(timesave+1))) {timecorrect=timecorrect+timesave-dts;
	  //printf("time corrected by %f",timecorrect);}
	  }
	  //printf ("pts %8.3f dts %8.3f\n",pts+timecorrect-starttime,dts+timecorrect-starttime);
	  timesave=dts;
	  Offset(timesave+timecorrect-starttime,myoff);
	  counter--;
	  if (counter<0) {
	    printf("Seeking input file [%1.1f%%]     \r",(timesave+timecorrect-starttime)*100.0/Tmax);counter=100;
	    fflush(stdout);
	  }
	  }
      
	else
	  {
	    if((pts<timesave)||(pts>(timesave+1))) {timecorrect=timecorrect+timesave-pts;
	    //printf("time corrected by %f",timecorrect);}
	    }
	    //printf("pts %8.3f\n",pts+timecorrect-starttime);
	    timesave=pts;
	    Offset(timesave+timecorrect-starttime,myoff);
	    counter--;
	    if (counter<0) {
	      printf("Seeking input file [%1.1f%%]      \r",(timesave+timecorrect-starttime)*100.0/Tmax);counter=100;
	      fflush(stdout);
	    }
	  }
      myoff=skipto;
      }
    }
  }else{
    while(FindNext(&myoff,0xb8)&&((timesave+timecorrect-starttime)<Tmax)){
      ReadGOPHeader(myoff,&pts);
      if((pts<timesave)||(pts>(timesave+1))) {timecorrect=timecorrect+timesave-pts;
      }
      timesave=pts;
      Offset(timesave+timecorrect-starttime,myoff);
      counter--;
      if (counter<0) {
	printf("Seeking input file [%1.1f%%] %1.3f      \r",(timesave+timecorrect-starttime)*100.0/Tmax,timesave+timecorrect-starttime);counter=3;
	fflush(stdout);
      }
    }
  }
  
  for(i=0; i<chunkcount;i++){
    if (stopO[i]==-1)  stopO[i]=FileSize;
  }
  
  printf("Seeking input file [100%%]              \n");
}

#ifndef _WIN32
inline
#endif 
void Offset(double time,offset off){
  int i;
  for(i=0; i<chunkcount;i++){
    if ((startO[i]==-1)&&(startT[i]<=time)) 
      startO[i]=off;
    if ((stopO[i]==-1)&&(stopT[i]<=time)) stopO[i]=off;
  }
}

int Demux(char* name){
  char filename[300];
  FILE *audio,*video;
  offset myoff;
  marker mymark;
  double trash;
  offset mypktsize;
  if(FileType!=SYSTEMFILE) {
    printf("Demux error, can only demultiplex a system file\n");
    return 0;
  }
  sprintf(filename,"%s.m1v",name);
  Confirm(filename);
  video= fopen(filename,"wb");
  if (video ==0) {
    perror("Unable to open output file ");
    return 0;
  }

  sprintf(filename,"%s.mp2",name);
  Confirm(filename);
  audio = fopen(filename,"wb");
  if (audio ==0) {
    perror("Unable to open output file ");
    fclose(video);
    return 0;
  }
  
  fseek(InFd,0L,SEEK_SET);
  myoff=0;
  while(myoff < FileSize){
    if(!FindNextMarker(&myoff,&mymark)) return 0;
    switch (mymark){
    case 0xe0:
      //vid part
      mypktsize=myoff+GetSize(myoff)+2;
      myoff+=2;
      ReadPacketTS(&myoff,&trash,&trash);
      copy(InFd,video,myoff,mypktsize);
      myoff=mypktsize;
      break;
    case 0xc0:
      mypktsize=myoff+GetSize(myoff)+2;
      myoff+=2;
      ReadPacketTS(&myoff,&trash,&trash);
      //while((GetByte(myoff)!=0xff)||((GetByte(myoff+1))!=0xfd)) myoff++;
      copy(InFd,audio,myoff,mypktsize);
      //myoff=mypktsize;
      break;
    case 0xbe:
      myoff=myoff+GetSize(myoff)+2;
      break;
    }
  }
  return 1;
  
}

#ifndef  _WIN32
inline
#endif 
void Confirm(char* filename){
  struct stat mystat;
  int mychar;
  int mytrash;
  if(!confirmall) return;
  if(stat(filename,&mystat)==-1){
    //ok
    //printf("erreur dans stat pour %s\n",filename);
    return;
  }
  else{
    printf("%s exists, overwrite? [Yes/No/Always] :",filename);
    mychar=getchar();
    do{ mytrash=getchar();}
    while (mytrash!='\n');

    switch(mychar){
    case 'Y':
    case 'y': return; 
    case 'a':
    case 'A': confirmall=0; return;
    default:
      printf("Canceled by user\n");
      exit(1);
    }
  }
}

int bitrate_index [2][3][16] =
    {{{0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0},
     {0,32,48,56,64,80,96,112,128,160,192,224,256,320,384,0},
      {0,32,40,48,56,64,80,96,112,128,160,192,224,256,320,0}},

{{0,32,48,56, 64,80 ,96 ,112,128,144,160,176,192,224,256,0},
     {0, 8,16,24,32,40,48, 56,64 ,80 ,96 ,112,128,144,160,0},
 {0, 8,16,24,32,40,48, 56,64 ,80 ,96 ,112,128,144,160,0}}};
  
int sampling_index [2][4] =
{
  {44100,48000,32000,0},
  {22050,24000,16000,0}
};

int ParseAudioHdr(offset off){
  //after the first 0xff
  int mylayer;
  int mympeg;
  int protect;
  int bitrate,sampling;
  int bitrateind;
  int samplingind;
  int mode;
  int padding;
  int modext;
  int emphasisind;
  if ((GetByte(off)&0xF0)!=0xF0){
    //mmm error should start with 0xfff
    return 0;
  }
  printf("Mpeg ");
  if(GetByte(off)&0x08) {
    mympeg=1;
    printf("1.0 ");
  }else
    {printf("2.0 ");mympeg=2;}
  
  mylayer=((GetByte(off)&0x06)>>1);
  switch(mylayer){
  case 1: mylayer=3; break;
  case 3: mylayer=1; break;
  }
  if (!mylayer){
    printf("Layer unknown :%d\n",mylayer);
    return 0;
  }
  
  else audiolayer=mylayer;
  protect=GetByte(off)&0x01;
  
  bitrateind=GetByte(off+1)>>4;
  samplingind=(GetByte(off+1)&0x0f)>>2;
  printf("%d kbits/s ",bitrate_index[mympeg-1][mylayer-1][bitrateind]);
  bitrate=bitrate_index[mympeg-1][mylayer-1][bitrateind];
  Byterate =(float)((bitrate*1000)/8.0);
  sampling=sampling_index[mympeg-1][samplingind];
  printf("%d Hz ",sampling_index[mympeg-1][samplingind]);
  if(GetByte(off+1)&0x02) {
    padding=1;}
  else {
    padding=0;
  }
  
  mode=GetByte(off+2)>>6;
  //  printf ("mode : %d\n",mode);
  if (mode==1){
    modext=(GetByte(off+2)>>4)&0x03;
    //printf("  extension %d\n",modext);
  }
  if(GetByte(off+2)&0x08) printf("(c) ");
  //  else printf("not copyrighted\n");
  if(GetByte(off+2)&0x04) printf("[original]\n");
  else printf("[copy]\n");

  emphasisind=GetByte(off+2)&0x03;
  //  printf("emphasis index : %d\n",emphasisind);
  
  
  if (mympeg==1){
    if (mylayer==1){
      audioframelength=48000*bitrate/sampling +padding;
    }else {
      audioframelength=144000*bitrate/sampling +padding;
    }
  }else if (mympeg ==2){
    if (mylayer==1){
      audioframelength=24000*bitrate/sampling +padding;
    }else {
      audioframelength=72000*bitrate/sampling +padding;
    }

  } else return 0;
  
  //  printf("audio frame length %ld\n",audioframelength);
  return 1;
  
    
}
