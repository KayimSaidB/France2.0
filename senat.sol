pragma solidity ^0.4.11;
/// french senator elections
import "gestionStructure.sol";

contract SystemeFranceSenat is gestionStructure{
    /// We start by defining citizens by an adress 
    // and what we call a role by default a citizen is a normal citizen
    
     /// Senators election works by voting for list of candidate
     ///two turn system for departement where we need 1-3 senators
     /// proportional system when it's over 3
     /// first structure is for two turn election 
   struct election 
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address[3]) candidateList; /// we set at three but if we want less senators we have to modify here
    
		mapping (uint => uint256) electionResults;
	} 

event rolecast(address citoyen, Roles sonrole);
/// vote for the Senat
function register(uint codepostal,uint numero_district, uint numberdepartement) returns(bool){
    if((citoyens[msg.sender].codepostal ==0) &&(citoyens[msg.sender].numerodistrict==0)){
    citoyens[msg.sender].codepostal=codepostal;
    citoyens[msg.sender].numerodistrict=numero_district;
    citoyens[msg.sender].numberdepartement=numberdepartement;
        return true;
    }
    return false;
}
    

function affichage_role(address[]citoyen_){
        for (uint256 i;i<citoyen_.length;i++){
            Roles petit=citoyens[citoyen_[i]].RoleDuCitoyen;
            rolecast(citoyen_[i],petit);
            
}
}
// each county has a list of Senators 
// so we create a mapping which links the number of Senators needed 
/// and the number of a county
mapping (uint=>election) liste_senat_pre_tour;
mapping (uint=>election) liste_senat_sec_tour;
//number of a county linked to each election case we have to elect a senator in two turn
// if the number of adresses is under 3 we need to fill every list with 0x0
//or modify this part
function start_a_senat_pre_tour(address[3][]candidats,uint number_departement){
        liste_senat_pre_tour[number_departement].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_senat_pre_tour[number_departement].candidateList[i]=candidats[i];
        liste_senat_pre_tour[number_departement].nbCandidates=candidats.length;
    }

/// when you vote for an election you chose 
/// we get the results with the address of the first candidate
event get_name(address[3]a_list, uint itsindice);
function show_me_the_candidates(uint number_departement){
    for (uint i=0;i<liste_senat_pre_tour[number_departement].nbCandidates;i++)get_name(liste_senat_pre_tour[number_departement].candidateList[i],i);
}


///we indentify a list by an index to vote
function vote_for_a_senat_pre_tour(uint indice_liste,uint number_departement) returns (bool){
if ((liste_senat_pre_tour[number_departement].hasVoted[msg.sender]==false) && (liste_senat_pre_tour[number_departement].isElecting==true) && (number_departement==citoyens[msg.sender].numberdepartement)){
          liste_senat_pre_tour[number_departement].electionResults[indice_liste]++;
          liste_senat_pre_tour[number_departement].hasVoted[msg.sender]=true;
          return true;
         }
    return false;    
    
    
}

function get_the_two_or_the_one_list(uint number_departement)returns(address[3][2]){
         liste_senat_pre_tour[number_departement].isElecting=false;
        address[3] winner=liste_senat_pre_tour[number_departement].candidateList[0];
        address [3]second=liste_senat_pre_tour[number_departement].candidateList[1];
        uint indicewinner=0;
        uint indicesecond=1;
        uint256 compteur=0;
       address[3][2] memory vainqueur;
       for (uint i=0;i<liste_senat_pre_tour[number_departement].nbCandidates;i++){
            if (liste_senat_pre_tour[number_departement].electionResults[i]>liste_senat_pre_tour[number_departement].electionResults[indicewinner]){
                second=winner;
                winner=liste_senat_pre_tour[number_departement].candidateList[i];
                indicesecond=indicewinner;
                indicewinner=i;
                
            }
            if (liste_senat_pre_tour[number_departement].electionResults[i]>liste_senat_pre_tour[number_departement].electionResults[indicesecond]){
                second=liste_senat_pre_tour[number_departement].candidateList[i];
                indicesecond=i;
            }
           compteur+=liste_senat_pre_tour[number_departement].electionResults[i]; 
        }
        
 if (liste_senat_pre_tour[number_departement].electionResults[indicewinner]>compteur/2){ 
     for (uint j=0;j<winner.length;j++)citoyens[winner[j]].RoleDuCitoyen=Roles.Senateur;
     
    vainqueur[0]=winner;
    return vainqueur;
    
 }
else { 
    
    vainqueur[0]=winner;
    vainqueur[1]=second;
    return vainqueur;
}
}

function start_a_senat_sec_tour(address[3][]candidats,uint number_departement){
        liste_senat_sec_tour[number_departement].isElecting=true;
        for(uint i=0;i<candidats.length;i++) liste_senat_sec_tour[number_departement].candidateList[i]=candidats[i];
        liste_senat_sec_tour[number_departement].nbCandidates=candidats.length;
    }
/// we indentify any list 
function vote_for_a_senat_sec_tour(uint indice_liste,uint number_departement) returns (bool){
if ((liste_senat_sec_tour[number_departement].hasVoted[msg.sender]==false) && (liste_senat_sec_tour[number_departement].isElecting==true) && (number_departement==citoyens[msg.sender].numberdepartement)){
          liste_senat_sec_tour[number_departement].electionResults[indice_liste]++;
          liste_senat_sec_tour[number_departement].hasVoted[msg.sender]=true;
          return true;
         }
    return false;    
    
    
}

///setting sentors 
function get_senators_after_second_tour(uint number_departement){
    address [3] memory winner;
    liste_senat_sec_tour[number_departement].isElecting=false;
    if(liste_senat_sec_tour[number_departement].electionResults[0]>liste_senat_sec_tour[number_departement].electionResults[1]){
    winner=liste_senat_sec_tour[number_departement].candidateList[0];
    }
    else winner=liste_senat_sec_tour[number_departement].candidateList[1];
    
       for (uint j=0;j<winner.length;j++)citoyens[winner[j]].RoleDuCitoyen=Roles.Senateur;

    
}
/// the case of proportional election 
   struct election_proportional 
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address[]) candidateList;/// we dont know how many candidates have a list
        uint nbcandidatesbylist;
		mapping (uint => uint256) electionResults;
		uint compteurvoix;
		mapping(uint =>uint) indicesenateur;/// a mapping of index to each list of candidate which indicate which index of the list has to be chosen 
	} 

mapping (uint=>election_proportional) liste_senat_proportional;
/// set to the maximal senators 
/*function show_me(uint number_departement){
    for(uint i=0;i<liste_senat_proportional[number_departement].nbCandidates;i++) cast3(liste_senat_proportional[number_departement].candidateList[i]);
}
*/
// when all list initalized we can start the proportional ballot
function start_a_proportional(uint number_departement){
        liste_senat_proportional[number_departement].isElecting=true;
        liste_senat_proportional[number_departement].nbcandidatesbylist=liste_senat_proportional[number_departement].candidateList[0].length;
    
}
/// we need to register every list separately before starting the proportional
function register_a_list_a_senat_proportional(address[]candidats,uint number_departement,uint indicelist){
         liste_senat_proportional[number_departement].candidateList[indicelist]=candidats;
    
       liste_senat_proportional[number_departement].nbCandidates++;
        
    
}
event cast3(address[]untel);
// we indentify a proportional list by an index 
function vote_for_a_proportional(uint indice_liste,uint number_departement) returns (bool){
if ((liste_senat_proportional[number_departement].hasVoted[msg.sender]==false) && (liste_senat_proportional[number_departement].isElecting==true) && (number_departement==citoyens[msg.sender].numberdepartement)){
          liste_senat_proportional[number_departement].electionResults[indice_liste]++;
          liste_senat_proportional[number_departement].hasVoted[msg.sender]=true;
          liste_senat_proportional[number_departement].compteurvoix++;
          return true;
         }
    return false;    
    
    
}
function get_senators_after_proportional(uint number_departement){
       uint nombresenateur=liste_senat_proportional[number_departement].nbcandidatesbylist;
    while(nombresenateur>0){
        uint senateurwinner=0;
        for (uint i=0;i<liste_senat_proportional[number_departement].nbCandidates;i++){
            if (liste_senat_proportional[number_departement].electionResults[senateurwinner]<liste_senat_proportional[number_departement].electionResults[i]) senateurwinner=i;
        
            
        }
        nombresenateur--;
        address nouveausenateur=liste_senat_proportional[number_departement].candidateList[senateurwinner][liste_senat_proportional[number_departement].indicesenateur[senateurwinner]];
        liste_senat_proportional[number_departement].indicesenateur[senateurwinner]++;
        uint nbdepute_previsonnel=liste_senat_proportional[number_departement].indicesenateur[senateurwinner]+1;
        liste_senat_proportional[number_departement].electionResults[senateurwinner]=liste_senat_proportional[number_departement].electionResults[senateurwinner]/nbdepute_previsonnel;

        citoyens[nouveausenateur].RoleDuCitoyen=Roles.Senateur;
        
    }    
    
    
}

//////////////////////////////////////////////////////////////////////////////////////
////////////////////////////Election président Sénat/////////////////

/// the President of the Senat  is elected with absolute majority
/// if we cant reach absolute majority twice, we must use relative majority
	 struct election_pdSenat
	{
		bool isElecting;
		uint nbCandidates;
		mapping (address => bool) hasVoted;
		mapping (uint => address) candidateList;
    
		mapping (address => uint256) electionResults;
	} 


election_pdSenat presidentSenat;
election presidentSenat2;


function start_president_senat(address[]candidats){
  presidentSenat.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presidentSenat.candidateList[i]=candidats[i];
        presidentSenat.nbCandidates=candidats.length;
    }

function voteforpresidentSenat(address candidat) returns (bool){
          if ((presidentSenat.hasVoted[msg.sender]==false) && (presidentSenat.isElecting==true) && (citoyens[msg.sender].RoleDuCitoyen==Roles.Senateur)){
              
              presidentSenat.electionResults[candidat]++;
              presidentSenat.hasVoted[msg.sender]=true;
              return true;
          }

    return false ; /// could be intersting to indicate the voter why it failed
}
/// gives us the new president of the National Assembly
function get_PresSenateur_normal() returns (address){
      address winner=presidentSenat.candidateList[0];
        uint256 compteur=presidentSenat.electionResults[winner];
        presidentSenat.isElecting=true;
         for (uint i=1;i<presidentSenat.nbCandidates;i++){
             if (presidentSenat.electionResults[presidentSenat.candidateList[i]]>presidentSenat.electionResults[winner]){
                 winner=presidentSenat.candidateList[i];
                 
             }
             compteur+=presidentSenat.electionResults[presidentSenat.candidateList[i]];
         }
        
     if (presidentSenat.electionResults[winner]>compteur/2) {
         
         citoyens[winner].RoleDuCitoyen=Roles.PresidentS;
     
         return winner;
     }
     else return 0x0;
    
  }
  
  /*
 function start_president_senat2(address[]candidats){
  presidentSenat2.isElecting=true;
        for(uint i=0;i<candidats.length;i++) presidentSenat2.candidateList[i]=candidats[i];
        presidentSenat2.nbCandidates=candidats.length;
    }

function voteforpresidentSenat2(address candidat) returns (bool){
          if ((presidentSenat2.hasVoted[msg.sender]==false) && (presidentSenat2.isElecting==true) && (citoyens[msg.sender].RoleDuCitoyen==Roles.Senateur)){
              
              presidentSenat2.electionResults[candidat]++;
              presidentSenat2.hasVoted[msg.sender]=true;
              return true;
          }

    return false ; /// could be intersting to indicate the voter why it failed
}
/// gives us the new president of the National Assembly
function get_PresSenateur_normal2() returns (address){
      address winner=presidentSenat2.candidateList[0];
        uint256 compteur=presidentSenat2.electionResults[winner];
        presidentSenat2.isElecting=true;
         for (uint i=1;i<presidentSenat2.nbCandidates;i++){
             if (presidentSenat2.electionResults[presidentSenat2.candidateList[i]]>presidentSenat.electionResults[winner]){
                 winner=presidentSenat.candidateList[i];
                 
             }
             compteur+=presidentSenat.electionResults[presidentSenat.candidateList[i]];
         }
        
     if (presidentSenat.electionResults[winner]>compteur/2) {
         
         citoyens[winner].RoleDuCitoyen=Roles.PresidentSenat;
     
         return winner;
     }
     else return 0x0;
    
  }
  
   
   */
   
}

