// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Pg_Agreement{

    struct Tenant{
        string name;
        uint age;
        string addres;
        uint basic_Rent;
        bool double_dose_vaccinated;
    }

    Tenant public tenant;
    Tenant[] public tenants_dir;
    uint counter;
    uint public total_tenants;
    uint public votes;
    mapping(address => bool) public vote;
    address public manager = msg.sender;


    modifier vaccinated(){
        require(msg.value == 3 wei, "Basic rent mismatched");
        require(manager != msg.sender, "Manager cannot register");  
        _;
    }

    function get_Register(string memory _name, uint _age, string memory _addres, bool _double_dose_vaccinated) payable public vaccinated{
        require(_double_dose_vaccinated == true, "You need to get vaccinated first");
        tenant.name = _name;
        tenant.age = _age;
        tenant.addres = _addres;
        tenant.double_dose_vaccinated = _double_dose_vaccinated;
        tenant.basic_Rent = msg.value;
        tenants_dir.push(tenant);
        total_tenants++;    
               
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function cleaning_done() public{
        counter++; 
    }

    function pay_Cleaning_Service_Rent() public payable {
        require(msg.value == 2 wei, "Basic rent mismatched");
        require(manager != msg.sender, "Manager cannot register");
        
        if(counter >= 8) {
            address payable user = payable(manager);
            user.transfer(msg.value);
        }

        else if(counter <= 7) {
            address payable user = payable(manager);
            user.transfer(msg.value/2);
            address payable tenant_return = payable(msg.sender);
            tenant_return.transfer(msg.value); //solve for this

        }

    }

    function food_Voting() public {
        
        require(vote[msg.sender] == false, "You already voted");
        vote[msg.sender] = true;
        votes++;

    }

    function pay_Food_Rent() public payable {
        require(msg.value == 2 wei, "Basic rent mismatched");
        require(manager != msg.sender, "Manager cannot register");       
        if(votes > total_tenants/2){
            address payable tenant_food_payment = payable(manager);
            tenant_food_payment.transfer(msg.value);
        }        
        else{
            address payable tenant_return_food_rent = payable(msg.sender);
            tenant_return_food_rent.transfer(msg.value/2); // solve for 1 wei
        }

    }
        
}







