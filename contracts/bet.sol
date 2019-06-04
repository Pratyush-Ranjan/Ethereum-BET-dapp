pragma solidity ^0.5.0;

contract bet{
	address payable public owner;
	uint256 public minibetprice;
	uint256 public noofbets;
	uint256 public totalbetprice;
	uint256 public maxnoofbets=20;
	address[] public players;

	struct Player{
		uint256 amountofbet;
		uint256 numberselected;
	}
	mapping(address=>Player)public playerinfo;

	function () external payable{}
	
	constructor(uint256 _minibetprice) public{
		owner=msg.sender;
		if(_minibetprice!=0)
		minibetprice=_minibetprice;
	}
	function kill() public{
		if(msg.sender==owner)
		selfdestruct(owner);
	}
	function checkplayerexists(address player)public view returns(bool){
		for(uint256 i=0;i<players.length;i++){
			if(players[i]==player)
			return true;
		}
		return false;
	}
	function betlaga(uint256 numberselect)public payable{
		require(!checkplayerexists(msg.sender));
		require(numberselect>=1 && numberselect<=10);
		require(msg.value>=minibetprice);

		playerinfo[msg.sender].amountofbet=msg.value;
		playerinfo[msg.sender].numberselected=numberselect;
		players.push(msg.sender);
		noofbets++;
		totalbetprice+=msg.value;
		if(noofbets>=maxnoofbets)
		givewinnumber();
	}
	function givewinnumber()public{
		uint256 winnernumber=block.number % 10 + 1;
		givewinnerprize(winnernumber);
	}
	function resetData() internal{
   players.length = 0;
   totalbetprice = 0;
   noofbets = 0;
}
	function givewinnerprize(uint256 winningnumber) public{
		address[100] memory winners;
		uint256 count=0;

		for(uint256 i=0;i<players.length;i++)
		{
			address playeraddress=players[i];
			if(playerinfo[playeraddress].numberselected==winningnumber){
			winners[count]=playeraddress;
			count++;
			}
			delete playerinfo[playeraddress];
		}
		uint256 winningamount = totalbetprice/winners.length;
		for(uint256 j=0;j<winners.length;j++)
		{
			if(winners[j]!=address(0))
			address(uint160(winners[j])).transfer(winningamount);
		}
		resetData();
	}

}