#include "script_component.hpp"

params ["_vector","_yaw","_pitch","_bank"]; 
	
[_vector]
matrixMultiply [[cos _yaw,sin _yaw,0],[sin -_yaw,cos _yaw,0],[0,0,1]]
matrixMultiply [[1,0,0],[0,cos -_pitch,sin -_pitch],[0,sin _pitch,cos -_pitch]]
matrixMultiply [[cos -_bank,0,sin _bank],[0,1,0],[sin -_bank,0,cos -_bank]] 
select 0
