#include <stdlib.h>
#include <stdio.h>

#test branch


#define MAX(a,b) \  
({ __typeof__ (a) _a = (a); \  
__typeof__ (b) _b = (b); \  
_a > _b ? _a : _b; })  
  
#define MIN(a,b) \  
({ __typeof__ (a) _a = (a); \  
__typeof__ (b) _b = (b); \  
_a < _b ? _a : _b; })


/*
works to do
1. longitudinal movement function
 --> based on CTM function
 --> function 
    --> input : (N, maxN, vf, maxY, w{wave speed}, dt)
    --> output : y {array}
 
2. lateral movement function
 --> LC probability : logit function (~ speed diff. / vf)
 
3. vehicle transmission function
*/

/*typedef struct {
	// about link
	int linkID;
	int fromNode;
	int toNode;
	int speedlimit;
	int roadlevel;	// 고속국도, 국도, 지방도
	int road_type;
	// about section
	int sectionID;
	int no_lanes;
	int cell_id;
	int speed;
	int numberOfVehicle;
	int length;
	int nextSectionID;
	int startSectionID;
	int endSectionID;
	int distanceToNode;
	int busLane;
	// yin
	int y_in;
	// lane_change
	// int lane_change;		// no need
	// insert vehicle
} lane_cell;
*/

typedef struct {
	int NoLane;
	int NoCell;
	int N[,];  		// 2D Array [NoCell	,NoLane]
	int MaxN[,];		// 2D Array [NoCell	,NoLane]
	int LC_left[,]; 	// 2D Array [NoCell	,NoLane]
	int LC_Right[,]; 	// 2D Array [NoCell	,NoLane]
	float V[,];		// 2D Array [NoCell	,NoLane]
	float Vf[,];		// 2D Array [NoCell	,NoLane]
	float Y[,];		// 2D Array [NoCell+1	,NoLane]
	float MaxY[,];		// 2D Array [NoCell	,NoLane]
	float CellLength[NoCell];
		
		
	int NextLink[NoLane]
	int NextLane[NoLane]
		
} link;


// hello this 

typedef struct {
	int nodeID;
	int type; 	// intersection, source, sink
	int speedlimit;
	int intersection_type;
	//connection_info
} node;

typedef struct {
	// current position
	int currentLane;
	int currentCell;
	int currentLink;
	int currentLinkOrder; // 
	// int distanceToNode;

	int type;
	
	int MandatoryLC;
	int moveForward;
	int moveRight;
	int moveLeft;
	
//	int freeflowspeed;
//	int minSpacing;
//	int reactionTime;
//	int driving_moment;
//	int lane_change;
	
	int path[20];  // Array of Links EX) [15, 17, 19,...,0,0] 
	int NoLinksinPath;  //size of array path path[NoLinksinPath]
	int targetLane1[]; // minimum Target Lane  EX) 2
	int targetLane2[]; // max Target Lane  Ex) 3
	
	
} vehicle;

/* 
*/


typedef struct {
	int startLinkID;
	int startSectionID;
	int startLaneID;
	int endLinkID;
	int endSectionID;
	int endLaneID;

	int greenTime;
	int LeftTime;
	int yellowTime;
	int redTime;
	int offset;
} turning_info;

__global__ void simulationStep(int loop_limit, link *linkcell, node *n,
		vehicle *v) {
	int tid = threadIdx.x;
	int i = blockIdx.x * blockDim.x + tid;

	// simulation time
		for (int current = 0; current < loop_limit; current++) {
			
			
			// Vehicle List에서 처리 
			
			
			for(int vehID = 0; vehID<size(vehList); vehID++){
				// Mandatory Lane Change 대상 차량 선정 
				veh=vehList(vehID);
				int TargetLaneLeft=vehList(vehID).targetLane1[(vehList(vehId).currentLinkOrder];
				int TargetLaneRight=vehList(vehID).targetLane2[(vehList(vehId).currentLinkOrder];
				
				if(veh.currentLane < TargetLaneLeft){veh.lanechange=1;}
				elseif(veh.currentLane < TargetLaneLeft) {veh.lanechange=-1;}
				else (veh.lanechange=0;) 	
			}
			
				// if vehicle 
				
		
				
				// Optional LC 
				
			
			
			
			
			for (int current_link = 0; current_link < sizeof(linkcell);
					i + current_link++) {
				
			//Lane Change Execution	
				
				
				
				

				// update v <= v_agent + v
				lc[current_link].speed = 60 * lc[current_link].numberOfVehicle;

				
				
				// y_out -> y_in
				lc[current_link].
					
				
				
					
					
					
				// record result

			}
										
										
			// Vehile Update 
										
			// 
			for(int vehID = 0; vehID<size(vehList); vehID++){
				vehicle_move(veh);			
			}							
										
	}
}
										
int vehicle_move(vehicle veh){
	if (veh.Lanechange = +1) {}	// Move vehicle to left lane 
	if (veh.Lanechange = -1) {} 	// Move vehicle to Right lane 	
	if (veh.moveforward = 1) {}     // Move vehicle to frent cell
}								
						

int main(void) {
	// simulation info
	int total_simulation_time = 100, period = 5;

	// set data size
	int numLaneCell = 16, gpuBlockSize = 4, lcSize = sizeof(lane_cell),
			numBytes = numLaneCell * lcSize, gpuGridSize = numLaneCell
					/ gpuBlockSize;
	int numNode = 16, nodeSize = sizeof(node), numNodesBytes = numNode
			* nodeSize;

	int numVehicle = 16, vehicleSize = sizeof(vehicle), numVehicleBytes =
			numVehicle * vehicleSize;

	int numVehicleQueue = 16, numVehicleQueueBytes = numVehicleQueue
			* vehicleSize;

	int numResult = total_simulation_time / period, numResultBytes = numResult
			* lcSize;

	// allocate memory
	lane_cell *cpuLCArray, *gpuLCArray;
	node *cpuNodeArray, *gpuNodeArray;
	vehicle *cpuVehicleArray, *gpuVehicleArray;
	lane_cell *cpuResultArray, *gpuResultArray;

	cpuLCArray = (lane_cell*) malloc(numBytes);
	cpuNodeArray = (node *) malloc(numNodesBytes);
	cpuVehicleArray = (vehicle *) malloc(numVehicleBytes);
	cpuResultArray = (lane_cell*) malloc(
			numBytes * total_simulation_time / period);

	// input initial data
	printf("%d\n", numBytes);
	printf("%d\n", numNodesBytes);
	printf("%d\n", numVehicleBytes);
	// copy host memory to device memory
	cudaMalloc((void**) &gpuLCArray, numBytes);
	cudaMalloc((void**) &gpuNodeArray, numNodesBytes);
	cudaMalloc((void**) &gpuVehicleArray, numVehicleBytes);

	// launch kernel
	simulationStep<<<gpuGridSize, gpuBlockSize>>>(numResult, gpuLCArray,
			gpuNodeArray, gpuVehicleArray);

	// retrieve the results
	cudaMemcpy(cpuResultArray, gpuResultArray, numResultBytes,
			cudaMemcpyDeviceToHost);
	// 필요없음
	// cudaMemcpy(cpuLCArray, gpuLCArray, numBytes, cudaMemcpyDeviceToHost);
	// cudaMemcpy(cpuNodeArray, gpuNodeArray, numNodesBytes, cudaMemcpyDeviceToHost);
	// cudaMemcpy(cpuVehicleArray, gpuNodeArray, numVehicleBytes, cudaMemcpyDeviceToHost);

	// record the simulation result
	printf("simulation results:\n");
	for (int i = 0; i < numResult; ++i) {
		//printf("point.a: %f, point.b: %f\n",cpuPointArray[i].a,cpuPointArray[i].b);
	}

	printf("end");

	// deallocate memory
	free(cpuLCArray);
	free(cpuNodeArray);
	free(cpuVehicleArray);
	free(cpuResultArray);

	cudaFree(gpuLCArray);
	cudaFree(gpuNodeArray);
	cudaFree(gpuVehicleArray);
	cudaFree(gpuResultArray);

	return 0;
}
