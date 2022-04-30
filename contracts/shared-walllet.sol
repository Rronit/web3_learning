pragma solidity ^0.8.7;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract sharedWallet is Ownable{
    // address public owner;
    mapping(address=>uint) public allowance;
    // constructor() public{
    //     owner = msg.sender;
    // }
    
    // modifier onlyOwner(){
    //     require(owner == msg.sender, "You are not owner, you dont have te permsion");
    //     _;
    // }
    function addAllowance(address _who, uint _amt) public onlyOwner{
        allowance[_who] = _amt;
    }
    modifier OwnerOrAllowance(uint _amt){
        require(owner() == msg.sender || allowance[msg.sender] >= _amt, "You dont have te permsion");
        _;
    }
    function withdrawMoney(address payable _to, uint _amt) public OwnerOrAllowance(_amt){
       
        _to.transfer(_amt);
    }
    fallback () external payable {

    }
    receive() external payable {
        // custom function code
    }
}