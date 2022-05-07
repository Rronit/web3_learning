pragma solidity ^0.8.7;

//for payment
contract Item{
    uint public priceInWei;
    uint public index;
    uint public pricePaid;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public{
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    receive()external payable{
        require(pricePaid == 0, "already paid");
        require(pricePaid == msg.value," only full payment allowed");
        pricePaid += msg.value;
        (bool success, )=address(parentContract).call{value:(msg.value)}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success,"failed, so canceling");
    }
    fallback() external{}
}


contract ItemManager{

    enum SupplyChainState{Created, Paid, Delivered}
    struct Item_Details{ 
        Item _Item;
        string _idenfitfier;
        uint _price;
        ItemManager.SupplyChainState _state;
    }
    mapping (uint=>Item_Details) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _state, address _itemaddress);

    function createItem(string memory _idenfitfier, uint _price) public{
        Item item = new Item(this, _price, itemIndex);
        items[itemIndex]._Item = item;
        items[itemIndex]._price = _price;
        items[itemIndex]._idenfitfier = _idenfitfier;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
        

    }
    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._price == msg.value,"Only full payment");
        require(items[_itemIndex]._state == SupplyChainState.Created,"Item is further in Chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._Item));



    }
    function triggerDelivery(uint _itemIndex) public {
         require(items[_itemIndex]._state == SupplyChainState.Paid,"Item is not paid");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._Item));


    }
}