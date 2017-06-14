pragma solidity ^0.4.11;

contract SystemeFranceSenat{
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
		mapping (uint => address[]) candidateList;
		mapping (address => uint256) electionResults;
	} 
mapping(address => carac_citoyen) citoyens;
event rolecast(address citoyen, Roles sonrole);
/// vote for the Senat
/*function register(uint codepostal,uint numero_district){
    citoyens[msg.sender].codepostal=codepostal;
    citoyens[msg.sender].numerodistrict=numero_district;
}
*/
function affichage_role(address[]citoyen_){
        for (uint256 i;i<citoyen_.length;i++){
            Roles petit=citoyens[citoyen_[i]].RoleDuCitoyen;
            rolecast(citoyen_[i],petit);
            
}
}
election Senat;
// each county has a list of Senators 
// so we create a mapping which links the number of Senators needed 
/// and the number of a county
mapping (uint =>uint) departement;
mapping (uint=>election) liste_senat_pre_tour; //  number of a county linked to each election case we have to elect a senator in two turn
function start_a_senat_pre_tour(address[3][]candidats,uint number_departement){
        liste_senat_pre_tour[number_departement].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_senat_pre_tour[number_departement].candidateList[i]=candidats[i];
        liste_senat_pre_tour[number_departement].nbCandidates=candidats.length;
    }

/// when you vote for an election you chose an array of addresses
/// you can vote 
function vote_for_a_senat_pre_tour(address [3]candidat,uint number_departement) returns (bool){
if ((liste_senat_pre_tour[number_departement].hasVoted[msg.sender]==false) && (liste_senat_pre_tour[number_departement].isElecting==true) && (number_departement==citoyens[msg.sender].numberdepartement)){
          liste_senat_pre_tour[number_departement].electionResults[candidat[0]]++;
          liste_senat_pre_tour[number_departement].hasVoted[msg.sender]=true;
          return true;
         }
    return false;    
    
    
}
/*
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
    liste_legislatives_sec_tour[number_district].isElecting=false;
    if(liste_legislatives_sec_tour[number_district].electionResults[liste_legislatives_sec_tour[number_district].candidateList[0]]>liste_legislatives_sec_tour[number_district].electionResults[liste_legislatives_sec_tour[number_district].candidateList[1]]){
    winner=liste_legislatives_sec_tour[number_district].candidateList[0];
    }
    else winner=liste_legislatives_sec_tour[number_district].candidateList[1];
    
    
citoyens[winner].RoleDuCitoyen=Roles.Depute;

    
}
//////////////////////////////////////////////////////////////////////////////////////
////////////////////////////Election président Assemblée Nationale/////////////////

/// the President of the National Assembly is elected with absolute majority
/// if we cant reach absolute majority twice, we must use relative majority
election presidentAN;
election presidentAN2;
election presidentAN3;

function start_president_AN(address[]candidats){
  presidentAN.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presidentAN.candidateList[i]=candidats[i];
        presidentAN.nbCandidates=candidats.length;
    }

function voteforPresidentAN(address candidat) returns (bool){
          if ((presidentAN.hasVoted[msg.sender]==false) && (presidentAN.isElecting==true) && (citoyens[msg.sender].RoleDuCitoyen==Roles.Depute)){
              
              presidentAN.electionResults[candidat]++;
              presidentAN.hasVoted[msg.sender]=true;
              return true;
          }

    return false ; /// could be intersting to indicate the voter why it failed
}
/// gives us the new president of the National Assembly
function get_Presdepute_normal() returns (address){
      address winner=presidentAN.candidateList[0];
        uint256 compteur=presidentAN.electionResults[winner];
        presidentAN.isElecting=true;
         for (uint i=1;i<presidentAN.nbCandidates;i++){
             if (presidentAN.electionResults[presidentAN.candidateList[i]]>presidentAN.electionResults[winner]){
                 winner=presidentAN.candidateList[i];
                 
             }
             compteur+=presidentAN.electionResults[presidentAN.candidateList[i]];
         }
        
     if (presidentAN.electionResults[winner]>compteur/2) {
         
         citoyens[winner].RoleDuCitoyen=Roles.PresidentAN;
     
         return winner;
     }
     else return 0x0;
    
  }
  
  /*
 function start_president_AN2(address[]candidats){
  presidentAN.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presidentAN.candidateList[i]=candidats[i];
        presidentAN.nbCandidates=candidats.length;
    }

function voteforPresidentAN2(address candidat) returns (bool){
          if ((presidentAN.hasVoted[msg.sender]==false) && (presidentAN.isElecting==true) && (citoyens[msg.sender].RoleDuCitoyen==Roles.Depute)){
              
              presidentAN.electionResults[candidat]++;
              presidentAN.hasVoted[msg.sender]=true;
              return true;
          }

    return false ; /// could be intersting to indicate the voter why it failed
}
/// gives us the new president of the National Assembly
function get_Presdepute_normal2() returns (address){
      address winner=presidentAN.candidateList[0];
        uint256 compteur=presidentAN.electionResults[winner];
        presidentAN.isElecting=true;
         for (uint i=1;i<presidentAN.nbCandidates;i++){
             if (presidentAN.electionResults[presidentAN.candidateList[i]]>presidentAN.electionResults[winner]){
                 winner=presidentAN.candidateList[i];
                 
             }
             compteur+=presidentAN.electionResults[presidentAN.candidateList[i]];
         }
        
     if (presidentAN.electionResults[winner]>compteur/2) {
         
         citoyens[winner].RoleDuCitoyen=Roles.PresidentAN;
     
         return winner;
     }
     else return 0x0;
    
  }
  
   */
   
}

