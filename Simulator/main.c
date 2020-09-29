#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int shiftAk[5] = {0};
int shiftCk [11] = {0};
const int NBitStream = 16;
int ak[16];
int ck_out[16];
int ck;
FILE *fd1, *fd2;
char choice;

/****************** Funzioni di utilità *************/

void shift(char ak, int i){
	for(int i = 3; i>=0; i--){
        shiftAk[i+1] = shiftAk[i];                     									 //shift di AK
    }
    for(int i = 9; i>=0; i--){
        shiftCk[i+1] = shiftCk[i];                     									 //shift di CK
    }
}

void printShiftRegs(int ClockIndex){
	printf("CLOCK: %d --------------print the shift registers after the shift operation----------------\n", ClockIndex+1);

	for(int i = 0; i<5; i++){
		printf("shiftAk[%d] = %d\n",i, shiftAk[i]);
	}

	printf("\n\n");

	for(int i = 0; i<11; i++){
		printf("shiftCk[%d] = %d\n",i, shiftCk[i]);
	}

	printf("\n\n");
}
void encode(){
	for(int i = 0; i<NBitStream; i++){
        ck = ( (shiftAk[2] ^ shiftAk[3]) ^ (shiftCk[7] ^ shiftCk[9]) ) ^ ak[i];             //calcolo ck
        ck_out[i] = ck;                                                                     //lo inserisco in ck_out
        shift(ak[i], i);                                                                    //shift, prende in ingresso l'attuale ak 
        shiftCk[0] = ck;                                                                    //inserisco in testa ck
        shiftAk[0] = ak[i];                                                                 //inserisco in testa ak
        printShiftRegs(i);
        
    }
}

void CompareFile(){
char buf[17];

fd2=fopen("OutputVhd.txt", "r");                                                    //apre il risultato del TestBench

	if( fd2==NULL ) {
		printf("Error: OutputVhd.txt cannot be opened!\n");
		exit(1);
	}
buf[0]=fgetc(fd2);

	for (int i = 0; i <= NBitStream; i++)
	{
    	buf[i]=fgetc(fd2);                                                     //leggo dal file
    	}

    for (int j = 0; j < NBitStream; j++)                                                     
    {
    	printf("VhdlOutput[%d] = %c , ",j, buf[j]);
    	printf("Simulator_C_Output[%d] = %d\n",j, ck_out[j]);
	 }
}

/********************************MAIN*********************/
int main()
{int i = 0;

	/* svuota i file  */
	fd1=fopen("InputVhd.txt", "w"); 
	fclose(fd1);
	fd2=fopen("OutputVhd.txt", "w"); 
	fclose(fd2);
    /* apre il file InputVhd in cui scrivere la stringa inserita dall'utente che verrà poi usato dal TB */
    fd1=fopen("InputVhd.txt", "a"); 

	/* verifica errori in apertura */
	if(fd1==NULL) {
		printf("Error: InputVhd.txt cannot be opened!\n");
		exit(1);
	}
    /*prendo i dati dall'utente*/
    printf("********** C simulator  **********\n");
    printf("Insert the 16 bit bit-stream. It will be saved in InputVhd.txt\n\n");

    while(i < NBitStream){
    	printf("Insert a binary value:\n");
    	scanf("%1d",&ak[i]);
    	if( ak[i]!=0 && ak[i]!=1 ){
    		printf("Error: you did not enter a binary value, please try again. %d to go!\n", (NBitStream-i));
    		}else{ 
    			i++;
    		}
    		fflush(stdin);
    	}
    /*codifico */
    encode();
    /*stampa la codifica*/ 
    printf("The result of the simulator is: \n");
    for(int i = 0; i<NBitStream; i++){
    	printf("ck[%d] = %d\n",i, ck_out[i]);
    }  

    /* scrive la stringa da codificare in InputVhd.txt*/
    for(int i = 0; i<NBitStream; i++){
    	fprintf(fd1, "%d", ak[i]);
    }
    printf("The output bit-stream has been saved in 'InputVhd.txt'\n");
	/*chiudo il file InputVhd.txt*/
	fclose(fd1);
	printf("Now it's possible to run the TestBench!\n Once ended, type 'S' to verify the correctness or type 'N' to quit\n");
	fflush(stdin);

	choice=getchar(); 
	/*In base alla decisione dell'utente confronto ck_out con OutputVhd*/
	if(choice == 83 || choice == 115){
		CompareFile(); 
	}
	else{
		printf("Closing all....done!\n");
	}
system("pause");
}
