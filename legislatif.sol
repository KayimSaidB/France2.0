pragma solidity ^0.4.11;
///French election of deputy (congressman)
import "./presidential.sol";

contract SystemeFranceLegislatif is SystemeFrancePresidentiel{
    /// We start by defining citizens by an adress 
    // and what we call a role by default a citizen is a normal citizen
  
event rolecast(address citoyen, Roles sonrole);
///enables a citizen to register himself with its postal code and its number of district
/// Maybe a register with all the codepostal linked to the number of district could be useful
///in order to have a more user friendly interface 

function affichage_role(address[]citoyen_){
        for (uint256 i;i<citoyen_.length;i++){
            Roles petit=citoyens[citoyen_[i]].RoleDuCitoyen;
            rolecast(citoyen_[i],petit);
            
}
}
/// we create a mapping which connect the number of district to an election
mapping(uint=>election ) liste_legislatives_pre_tour;
mapping(uint=>election ) liste_legislatives_sec_tour;
/// a mapping of all deputy
mapping(uint=>address) register_deputy;
// each election is represented by its number of district from 1 to 577
/// for one district
mapping(bytes32 => address[])registre_parti; /// links the name of a party to all memebers
mapping(bytes32 => bytes32[]) registre_groupe_politique; // links the name of a political group to all the party inside


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
/// get the new deputy of the two which are going to second turn
function set_the_two_or_the_one_depute(uint number_district)returns(address[2]){
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
     register_deputy[number_district]=winner;
    vainqueur[0]=winner;
    registre_parti[citoyens[winner].PartiPolitique].push(winner);
    
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

function set_depute_after_second_tour(uint number_district){
    address winner;
    liste_legislatives_sec_tour[number_district].isElecting=false;
    if(liste_legislatives_sec_tour[number_district].electionResults[liste_legislatives_sec_tour[number_district].candidateList[0]]>liste_legislatives_sec_tour[number_district].electionResults[liste_legislatives_sec_tour[number_district].candidateList[1]]){
    winner=liste_legislatives_sec_tour[number_district].candidateList[0];
    }
    else winner=liste_legislatives_sec_tour[number_district].candidateList[1];
    
    
citoyens[winner].RoleDuCitoyen=Roles.Depute;
register_deputy[number_district]=winner;
  registre_parti[citoyens[winner].PartiPolitique].push(winner);


    
}
function get_my_deputy( uint number_district) returns (address){
    return register_deputy[number_district];
}
function join_political_group(bytes32 groupe_politique, bytes32 parti){
    registre_groupe_politique[groupe_politique].push(parti);
}
function get_number_siege(bytes32 parti_politique) returns (uint){
    
    return registre_parti[parti_politique].length;
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
function set_Presdepute_normal() returns (address){
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
  
  /* /// if needed
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
function set_Presdepute_normal2() returns (address){
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

