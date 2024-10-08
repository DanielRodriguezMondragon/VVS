//Global variables

#define N 3
#define CAP 10
#define mutex (cash + loan[0] + loan[1] + loan[2] == 10)
short max[N] = {2,4,3};// Maximum money needed by each client
short loan[N] = 0;// Current amount lent to each client
short cash = CAP;// Money in the bank (initially,the capital CAP)

active[N] proctype Cliente() {
	short request;
	short max_req;
	
	do
// has not reached her maximum loan -> pedimos dinero
	:: loan[_pid] < max[_pid] -> 
		max_req = max[_pid] - loan[_pid];
		select(request: 1..max_req);
		req:  printf("C%d requests %d.   %d:[%d,%d,%d]\n",_pid,request,cash,loan[0],loan[1],loan[2]);
		cash >= request;// espera a que haya dinero en el banco
// cogemos prestado el dinero
		atomic {
			cash = cash - request;
			loan[_pid] = loan[_pid] + request;
			printf("C%d got money %d.   %d:[%d,%d,%d]\n",_pid,request,cash,loan[0],loan[1],loan[2]);
		}
// the client has any loan greater than 0, she can return it at any moment.
	:: loan[_pid] > 0 -> 
		select(request: 1..loan[_pid]);
		atomic {
			cash = cash + request;
			loan[_pid] = loan[_pid] - request;
			printf("C%d returns its loan %d.   %d:[%d,%d,%d]\n",_pid,request,cash,loan[0],loan[1],loan[2]);
		}
	od
}