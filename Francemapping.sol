pragma solidity ^0.4.11;

contract SystemeFrance{
    /// We start by defining citizens by an adress
    // and what we call a role by default a citizen is a normal citizen
    enum Roles{Simple_citoyen,Depute,Senateur,President,Conseiller_constit}
      struct Voter {
        bool votedP;bool voteD;bool votedS;
        Roles RoleDuCitoyen;

      }

    mapping(address => Voter) citoyens;

event voteCast(address citoyen, Roles place, bool voted);
event voteCast2(address chien);
function affichage_role(address[]citoyen_){

        for (uint256 i;i<citoyen_.length;i++){
            voteCast(citoyen_[i],citoyens[citoyen_[i]].RoleDuCitoyen,citoyens[citoyen_[i]].votedP);

}
}

/// du point de vue du votant cette fonction
mapping(address =>uint256) listecandidat;
function vote_for_president(address candidat){
      if (citoyens[msg.sender].votedP==false){
          listecandidat[candidat]++;
          citoyens[msg.sender].votedP=true;
          voteCast2(msg.sender);
      }

}

}
