pragma solidity ^0.4.11;
import "gestionStructure.sol";
contract ConseilConstitutionnel is gestionStructure{
struct un_conseil{
    
    address[]conseil_constitutionnel;
	mapping (address => bool) hasElected;

    
}
un_conseil le_conseil;

function send_three(address[3]proposals) returns (bool){
    if (((citoyens[msg.sender].RoleDuCitoyen==Roles.PresidentR)&& (le_conseil.hasElected[msg.sender]==false)) || ((citoyens[msg.sender].RoleDuCitoyen==Roles.PresidentAN)&& (le_conseil.hasElected[msg.sender]==false)) || ((citoyens[msg.sender].RoleDuCitoyen==Roles.PresidentS)&& (le_conseil.hasElected[msg.sender]==false)))
{   for (uint i=0;i<proposals.length;i++) le_conseil.conseil_constitutionnel.push(proposals[i]);      
     le_conseil.hasElected[msg.sender]=true;
    return true;
    
}
   return false;

       
       
       
       
   
}

function set_conseil_consititutionnel(){
    
    for( uint i=0;i<le_conseil.conseil_constitutionnel.length;i++) citoyens[le_conseil.conseil_constitutionnel[i]].RoleDuCitoyen=Roles.Conseiller_constit;
    
}
    
    
    
}
