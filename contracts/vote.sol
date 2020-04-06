pragma solidity ^0.5.0;

contract vote {

    // L'adresse du compte qui crée et gère le vote
    address public garage;

    //Pour gérer la fin du vote
    bool public VoteEnd;

    // Nom des listes participante
    bytes32[] public listeName;


    uint256 public totalVotes;

    uint256 public penalities;
    //Verifie si la personne a déja voté
    mapping(address=> bool) public hasVoted;

    //Récupère la valeur du vote
    mapping(bytes32 => uint256)private votesReceived;

    //Crée un bulletin de vote
    constructor(bytes32[] _listeName) public{
        //Indique au propriétaire du contact qui est
        //en train de le modifier
        garage = msg.sender;
        listeName= _listeName;
    }

    function voteForListe(bytes32 liste)public{
        //Si ce n'est PAS la fin du vote
        require(!VoteEnd)
        //La liste d
        require(validListe(liste))
        //Une address, Un vote
        require(!hasVoted[msg.sender]);

        //Pour chaque votr la liste gagne une voix
        votesReceived[liste] +=1;
        //Limite le vote à une fois par adresse
        hasVoted[msg.sender]=true;
        totalVotes +=1;
    }

    function endVote() public returns(bool){
        //Seul le gestionnaire peut stoper le vote
        require(msg.sender == garage);
        VoteEnd=true;
        return true;
    }

    function totalVotesFor(bytes32 liste) view public returns(uint256){
        require(validListe(liste));
        require(VoteEnd); //ne peut montrer le resultat avant la fin
        return votesReceived[liste];
    }

    function penalities(bytes32 liste) public{
        require(validListe(liste));
        votesReceived[liste] -= penalities; //déduit les penalities
    }
}
