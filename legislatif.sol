pragma solidity ^0.4.11;

contract SystemeFranceLegislatif{
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

mapping(uint=>election ) liste_legislatives_pre_tour;
mapping(uint=>election ) liste_legislatives_sec_tour;

// each election is represented by its number of district from 1 to 577
/// for one district 
function start_a_legi_pre_tour(address[]candidats,uint number_district){
        liste_legislatives_pre_tour[number_district].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_legislatives_pre_tour[number_district].candidateList[i]=candidats[i];
        liste_legislatives_pre_tour[number_district].nbCandidates=candidats.length;
    }

/// when you vote for an election you chose the address of your candidat
/// and the number district, you can only vote if your own number of district matches
function vote_for_a_legi_pre_tour(address candidat,uint number_district) returns (bool){
if ((liste_legislatives_pre_tour[number_district].hasVoted[msg.sender]==false) && (liste_legislatives_pre_tour[number_district].isElecting==true) && (number_district==citoyens[msg.sender].numerodistrict)){
          liste_legislatives_pre_tour[number_district].electionResults[candidat]++;
          liste_legislatives_pre_tour[number_district].hasVoted[msg.sender]=true;
          return true;
         }
    return false;    
    
    
}
function get_the_two_or_the_one_depute(uint number_district)returns(address[2]){
         liste_legislatives_pre_tour[number_district].isElecting=false;
        address winner=liste_legislatives_pre_tour[number_district].candidateList[0];
        address second=liste_legislatives_pre_tour[number_district].candidateList[1];
       
        uint256 compteur=0;
       address[2] memory vainqueur;
        for (uint i=0;i<liste_legislatives_pre_tour[number_district].nbCandidates;i++){
            if (liste_legislatives_pre_tour[number_district].electionResults[liste_legislatives_pre_tour[number_district].candidateList[i]]>liste_legislatives_pre_tour[number_district].electionResults[winner]){
                second=winner;
                winner=liste_legislatives_pre_tour[number_district].candidateList[i];
                }
            if (liste_legislatives_pre_tour[number_district].electionResults[liste_legislatives_pre_tour[number_district].candidateList[i]]>liste_legislatives_pre_tour[number_district].electionResults[second]){
                second=liste_legislatives_pre_tour[number_district].candidateList[i];
            
            }
           compteur+=liste_legislatives_pre_tour[number_district].electionResults[liste_legislatives_pre_tour[number_district].candidateList[i]]; 
        }
        
 if (liste_legislatives_pre_tour[number_district].electionResults[winner]>compteur/2){ 
     citoyens[winner].RoleDuCitoyen=Roles.Depute;
    vainqueur[0]=winner;
    return vainqueur;
    
 }
else { 
    vainqueur[0]=winner;
    vainqueur[1]=second;
    return vainqueur;
}
}
function start_a_legi_sec_tour(address[]candidats,uint number_district){
        liste_legislatives_sec_tour[number_district].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_legislatives_sec_tour[number_district].candidateList[i]=candidats[i];
        liste_legislatives_sec_tour[number_district].nbCandidates=candidats.length;
    }
function vote_for_secondtour_legi(address candidat,uint number_district) returns (bool){
      if ((liste_legislatives_sec_tour[number_district].hasVoted[msg.sender]==false) && (liste_legislatives_sec_tour[number_district].isElecting==true) && (citoyens[msg.sender].numerodistrict==number_district)){
          liste_legislatives_sec_tour[number_district].electionResults[candidat]++;
          liste_legislatives_sec_tour[number_district].hasVoted[msg.sender]=true;
          return true;
         }
    return false;
}

function get_depute_after_second_tour(uint number_district){
    address winner;
    if(liste_legislatives_sec_tour[number_district].electionResults[liste_legislatives_sec_tour[number_district].candidateList[0]]>liste_legislatives_sec_tour[number_district].electionResults[liste_legislatives_sec_tour[number_district].candidateList[1]]){
    winner=liste_legislatives_sec_tour[number_district].candidateList[0];
    }
    else winner=liste_legislatives_sec_tour[number_district].candidateList[1];
    
    
citoyens[winner].RoleDuCitoyen=Roles.Depute;

    
}

}

