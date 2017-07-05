pragma solidity ^0.4.11;
contract gestionStructure{
    
     enum Roles{Simple_citoyen,PresidentR,Conseiller_local,Depute,PresidentAN,Senateur,PresidentS,Conseiller_constit}
    struct carac_citoyen{
         bytes32 name;
         uint codepostal;
         Roles RoleDuCitoyen;
         uint numerodistrict;
        uint numberdepartement;
        bytes32 PartiPolitique;
     } 
     mapping(address => carac_citoyen) citoyens; /// the regisiter of citizen, they have an address connected to citizen characteristics

    
      struct election 
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address) candidateList;
		mapping (address => uint256) electionResults;
	} 
    function register(uint codepostal,uint numero_district,uint numerodepartement) returns(bool){
    // prevent from register multiple times 
    if((citoyens[msg.sender].codepostal ==0) &&(citoyens[msg.sender].numerodistrict==0)){
    citoyens[msg.sender].codepostal=codepostal;
    citoyens[msg.sender].numerodistrict=numero_district;
     citoyens[msg.sender].numberdepartement=numerodepartement;
    
        return true;
    }
    return false;
}
// you can join a political party 
function join_a_party(bytes32 nouveauparti){citoyens[msg.sender].PartiPolitique=nouveauparti;}
function make_someone_join_a_party(address personne, bytes32 nouveauparti){citoyens[personne].PartiPolitique=nouveauparti;}
}
