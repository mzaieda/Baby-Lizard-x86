#include<iostream>

using namespace std;

	int col[30];
	int rd[30];
	int ld[30];
	int array1[15][15] = {0};
	
void printFinalint(int n){
	
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            cout<<array1[i][j]<<" ";
        }
        cout<<endl;
    }
    cout<<endl;
}


void solveBits(int r,int n,int &num){
	if(r==n){ num++; printFinalint(n); return; }
		for(int c=0;c<n;c++){
			if(!col[c] && !rd[r-c+n-1] && !ld[r+c]){
			col[c] = rd[r-c+n-1] = ld[r+c] = array1[r][c] = 1;
			solveBits(r+1,n,num);
			col[c] = rd[r-c+n-1] = ld[r+c] = array1[r][c] = 0;
			}
		}
}

void fillBits(int r,int n, int &num){

    if(r==n){ cout << endl; solveBits(0,n,num); return; }
	if(r == 0)
		cout << "First Row: ";
	else
		cout << "New Row: ";

		for(int f=0; f<n;f++){
			int k;
			cin >> k;
				col[f] = rd[r-f+n-1] = ld[r+f] = k;
		}
            fillBits(r+1,n,num);
}


int main(){
    int n;
	cout << "Enter N: ";
    cin>>n;
    int num=0;
	fillBits(0, n, num);
    cout<<num<<endl;
}
