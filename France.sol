pragma solidity ^0.4.11;

contract SystemeFrance{
    /// We start by defining citizens by an adress
    // and what we call a role by default a citizen is a normal citizen
    enum Roles{Simple_citoyen,Depute,Senateur,President,Conseiller_constit}
    struct un_citoyen{
        address adresse;
        Roles role_citoyen;
         }
  un_citoyen[99] registre;

    function creationregistrecitoyen(address[]citoyen_)
{
    for (uint256 i=0;i<99;i++){
    registre[i].adresse=0x3;
    }

}
event voteCast(address citoyen, Roles place);

function affichage_role(){

        for (uint256 i;i<registre.length;i++){
            voteCast(registre[i].adresse,registre[i].role_citoyen);

}
}



}
