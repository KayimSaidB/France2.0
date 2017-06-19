pragma solidity ^0.4.11;
///local election (regional, departemental can be done with this)
/// works just like the election of Deputy
contract SystemeFranceLocal{
    /// We start by defining citizens by an adress 
    // and what we call a role by default a citizen is a normal citizen
    enum Roles{Simple_citoyen,PresidentR,Conseiller_local,Depute,PresidentAN,Senateur,PresidentS,Conseiller_constit}
     
     struct carac_citoyen{
         uint codepostal;
         Roles RoleDuCitoyen;
         uint numerodistrict;
         uint numberdepartement;

     } 
   struct election 
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address) candidateList;
		mapping (address => uint256) electionResults;
	} 
	///This code is designed for local election but can be adapted to any regional-like
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
/// we create a mapping with election and the postal code connected
mapping(uint=>election ) liste_locales_pre_tour;
mapping(uint=>election ) liste_locales_sec_tour;

// each election is represented by its postal code 
/// for one city
function start_a_legi_pre_tour(address[]candidats,uint postal_code){
        liste_locales_pre_tour[postal_code].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_locales_pre_tour[postal_code].candidateList[i]=candidats[i];
        liste_locales_pre_tour[postal_code].nbCandidates=candidats.length;
    }

/// when you vote for an election you chose the address of your candidate
/// and the number district, you can only vote if your own number of district matches
function vote_for_a_legi_pre_tour(address candidat,uint postal_code) returns (bool){
if ((liste_locales_pre_tour[postal_code].hasVoted[msg.sender]==false) && (liste_locales_pre_tour[postal_code].isElecting==true) && (postal_code==citoyens[msg.sender].codepostal)){
          liste_locales_pre_tour[postal_code].electionResults[candidat]++;
          liste_locales_pre_tour[postal_code].hasVoted[msg.sender]=true;
          return true;
         }
    return false;    
    
    
}
function get_the_two_or_the_one_conseiller(uint postal_code)returns(address[2]){
         liste_locales_pre_tour[postal_code].isElecting=false;
        address winner=liste_locales_pre_tour[postal_code].candidateList[0];
        address second=liste_locales_pre_tour[postal_code].candidateList[1];
       
        uint256 compteur=0;
       address[2] memory vainqueur;
        for (uint i=0;i<liste_locales_pre_tour[postal_code].nbCandidates;i++){
            if (liste_locales_pre_tour[postal_code].electionResults[liste_locales_pre_tour[postal_code].candidateList[i]]>liste_locales_pre_tour[postal_code].electionResults[winner]){
                second=winner;
                winner=liste_locales_pre_tour[postal_code].candidateList[i];
                }
            if (liste_locales_pre_tour[postal_code].electionResults[liste_locales_pre_tour[postal_code].candidateList[i]]>liste_locales_pre_tour[postal_code].electionResults[second]){
                second=liste_locales_pre_tour[postal_code].candidateList[i];
            
            }
           compteur+=liste_locales_pre_tour[postal_code].electionResults[liste_locales_pre_tour[postal_code].candidateList[i]]; 
        }
        
 if (liste_locales_pre_tour[postal_code].electionResults[winner]>compteur/2){ 
     citoyens[winner].RoleDuCitoyen=Roles.Conseiller_local;
    vainqueur[0]=winner;
    return vainqueur;
    
 }
else { 
    vainqueur[0]=winner;
    vainqueur[1]=second;
    return vainqueur;
}
}
function start_a_lcl_sec_tour(address[]candidats,uint postal_code){
        liste_locales_sec_tour[postal_code].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_locales_sec_tour[postal_code].candidateList[i]=candidats[i];
        liste_locales_sec_tour[postal_code].nbCandidates=candidats.length;
    }
function vote_for_secondtour_lcl(address candidat,uint postal_code) returns (bool){
      if ((liste_locales_sec_tour[postal_code].hasVoted[msg.sender]==false) && (liste_locales_sec_tour[postal_code].isElecting==true) && (postal_code==citoyens[msg.sender].codepostal)){
          liste_locales_sec_tour[postal_code].electionResults[candidat]++;
          liste_locales_sec_tour[postal_code].hasVoted[msg.sender]=true;
          return true;
         }
    return false;
}

function get_conseiller_lcl_after_second_tour(uint postal_code){
    address winner;
    liste_locales_sec_tour[postal_code].isElecting=false;
    if(liste_locales_sec_tour[postal_code].electionResults[liste_locales_sec_tour[postal_code].candidateList[0]]>liste_locales_sec_tour[postal_code].electionResults[liste_locales_sec_tour[postal_code].candidateList[1]]){
    winner=liste_locales_sec_tour[postal_code].candidateList[0];
    }
    else winner=liste_locales_sec_tour[postal_code].candidateList[1];
    
    
citoyens[winner].RoleDuCitoyen=Roles.Conseiller_local;

    
}
}
