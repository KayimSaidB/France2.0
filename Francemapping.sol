pragma solidity ^0.4.11;

contract SystemeFrancePresidentiel{
    /// We start by defining citizens by an adress 
    // and what we call a role by default a citizen is a normal citizen
    enum Roles{Simple_citoyen,Conseiller_local,Depute,Senateur,President,Conseiller_constit}
     
     struct carac_citoyen{
         uint codepostal;
         Roles RoleDuCitoyen;
         uint numerodistrict;
     } 
   struct election 
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address) candidateList;
		mapping (address => uint256) electionResults;
	} 
mapping(address => carac_citoyen) citoyens;
event rolecast(address citoyen, Roles sonrole);
///enables a citizen to register himself with its postal code and its number of district
/// Maybe a register with all the codepostal linked to the number of district could be useful
///in order to have a more user friendly interface 
function register(uint codepostal,uint numero_district){
    citoyens[msg.sender].codepostal=codepostal;
    citoyens[msg.sender].numerodistrict=numero_district;
}


function affichage_role(address[]citoyen_){
        for (uint256 i;i<citoyen_.length;i++){
            Roles petit=citoyens[citoyen_[i]].RoleDuCitoyen;
            rolecast(citoyen_[i],petit);
            
}
}


election presi_pre_tour;
election presi_sec_tour;
/// starts presidential election
function start_pres_pre_tour(address[]candidats){
        presi_pre_tour.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presi_pre_tour.candidateList[i]=candidats[i];
        presi_pre_tour.nbCandidates=candidats.length;
    
}
function start_pres_sec_tour(address[]candidats){
        presi_sec_tour.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presi_sec_tour.candidateList[i]=candidats[i];
        presi_sec_tour.nbCandidates=candidats.length;
}


//from the voter  
function vote_for_premiertour(address candidat) returns (bool){
      if ((presi_pre_tour.hasVoted[msg.sender]==false) && (presi_pre_tour.isElecting==true)){
          presi_pre_tour.electionResults[candidat]++;
          presi_pre_tour.hasVoted[msg.sender]=true;
          return true;
         }
    return false;
}


// ends presidential election and set the new president
function get_the_two_or_the_one_president()returns(address[2]){
         presi_pre_tour.isElecting=false;
        address winner=presi_pre_tour.candidateList[0];
        address second=presi_pre_tour.candidateList[1];
       
        uint256 compteur=0;
       address[2] memory vainqueur;
        for (uint i=0;i<presi_pre_tour.nbCandidates;i++){
            if (presi_pre_tour.electionResults[presi_pre_tour.candidateList[i]]>presi_pre_tour.electionResults[winner]){
                second=winner;
                winner=presi_pre_tour.candidateList[i];
                }
            if (presi_pre_tour.electionResults[presi_pre_tour.candidateList[i]]>presi_pre_tour.electionResults[second]){
                second=presi_pre_tour.candidateList[i];
            
            }
           compteur+=presi_pre_tour.electionResults[presi_pre_tour.candidateList[i]]; 
        }
        
 if (presi_pre_tour.electionResults[winner]>compteur/2){ 
     citoyens[winner].RoleDuCitoyen=Roles.President;
    vainqueur[0]=winner;
    return vainqueur;
    
 }
else { 
    vainqueur[0]=winner;
    vainqueur[1]=second;
    return vainqueur;
}
}
function vote_for_secondtour(address candidat) returns (bool){
      if ((presi_sec_tour.hasVoted[msg.sender]==false) && (presi_sec_tour.isElecting==true)){
          presi_sec_tour.electionResults[candidat]++;
          presi_sec_tour.hasVoted[msg.sender]=true;
          return true;
         }
    return false;
}

function get_president_after_second_tour(){
    address winner;
    if(presi_sec_tour.electionResults[presi_sec_tour.candidateList[0]]>presi_pre_tour.electionResults[presi_sec_tour.candidateList[1]]){
     winner=presi_sec_tour.candidateList[0];
    }
    else winner=presi_sec_tour.candidateList[1];
    
    
citoyens[winner].RoleDuCitoyen=Roles.President;

    
}


    
    
    
}
