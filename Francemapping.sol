pragma solidity ^0.4.11;

contract SystemeFrance{
    /// We start by defining citizens by an adress 
    // and what we call a role by default a citizen is a normal citizen
    enum Roles{Simple_citoyen,Depute,Senateur,President,Conseiller_constit}
     
      
   struct election 
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address) candidateList;
		mapping (address => uint256) electionResults;
	} 
mapping(address => Roles) citoyens;
event rolecast(address citoyen, Roles sonrole);
function affichage_role(address[]citoyen_){
        for (uint256 i;i<citoyen_.length;i++){
            Roles petit=citoyens[citoyen_[i]];
            rolecast(citoyen_[i],petit);
            
}
}


election presidentielles;
/// starts presidential election
function start_pres(address[]candidats){
        presidentielles.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presidentielles.candidateList[i]=candidats[i];
        presidentielles.nbCandidates=candidats.length;
    
}



/// from the voter  
function vote_for_president(address candidat) returns (bool){
      if ((presidentielles.hasVoted[msg.sender]==false) && (presidentielles.isElecting==true)){
          presidentielles.electionResults[candidat]++;
          presidentielles.hasVoted[msg.sender]=true;
          return true;
         }
    return false;
}
// ends presidential election and set the new president
function get_the_new_president(){
         presidentielles.isElecting=false;

        address winner=presidentielles.candidateList[0];

        for (uint i=1;i<presidentielles.nbCandidates;i++){
            if (presidentielles.electionResults[presidentielles.candidateList[i]]>presidentielles.electionResults[winner]){
                winner=presidentielles.candidateList[i];
                
            }
            
        }
    citoyens[winner]=Roles.President;
    
    
}



}

