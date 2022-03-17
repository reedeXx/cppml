//Suma de dos vectores 
#include <stdio.h>
 #include <iostream>

using namespace std;
 
int main(){
	
double  b [3];

double  a [3];

double  c [3];

for (int i=0; i<=3; i=i+1 ){
 
	 printf("Introduce datos en el vector"); cin >> a[i];

}

for (int i=0; i<=3; i=i+1 ){
 
	 printf("Introduce datos en el vector"); cin >> b[i];

}

for (int i=0; i<=3; i=i+1 ){
 
	 c[i]=b[i]+a[i];

}

for (int i=0; i<=3; i=i+1 ){
 
	 cout << i << " --> " << c[i] << endl;

}


	return 0;

}