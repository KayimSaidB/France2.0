pragma solidity ^0.4.11;
contract gestionStructure{
    
     enum Roles{Simple_citoyen,PresidentR,Conseiller_local,Depute,PresidentAN,Senateur,PresidentS,Conseiller_constit}
    struct carac_citoyen{
         bytes32 name;
         uint codepostal;
         Roles RoleDuCitoyen;
         uint numerodistrict;
        uint numberdepartement;

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
    
    
}
