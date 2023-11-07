//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.5.0;
contract Lottery{
    address public manager;// storing address of manager
    address payable[] public participants;// whenever payment has to be done we use payable

    constructor()
    {
        manager=msg.sender; //  sending message to the manager----global variable

    }
    receive() external payable {
        require(msg.value==1 ether,"insufficient amount spent");// checks if ether transefers is 1 or not
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns (uint)
    {   require(msg.sender==manager,"You are not manager");// as only manager should be able to see the total amount
        return address(this).balance;
    }
    function number_of_participants()public view returns(uint)
    {
        return participants.length;
    }
    function random() public view returns(uint)
    {
       return  uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));//generally dont use this
    }
    function selectWinner()public 
    {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();// randomly selecting a particpant
        address payable winner;
        uint index=r%participants.length;// getting index of the winner
        winner=participants[index];// getting addres of the winner
        winner.transfer(getBalance());// transferring all the balance to the winner
        participants=new address payable[](0);
    
    }
}