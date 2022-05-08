pragma solidity ^0.8.7;

contract ItemManager{

    enum SupplyChainState{Created, Paid, Delivered}
    struct Item_Details{
        string _idenfitfier;
        uint _price;
        ItemManager.SupplyChainState _state;
    }
    mapping (uint=>Item_Details) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _state);

    function createItem(string memory _idenfitfier, uint _price) public{
        items[itemIndex]._price = _price;
        items[itemIndex]._idenfitfier = _idenfitfier;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
        itemIndex++;

    }
    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._price == msg.value,"Only full payment");
        require(items[_itemIndex]._state == SupplyChainState.Created,"Item is further in Chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state));



    }
    function triggerDelivery(uint _itemIndex) public {
         require(items[_itemIndex]._state == SupplyChainState.Paid,"Item is not paid");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state));


    }
}