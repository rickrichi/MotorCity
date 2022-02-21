// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ERC20.sol";
import "./Ownable.sol";

contract MotorCityToken is ERC20 {
     constructor() ERC20('MotorCity', 'MC') {
    _mint(msg.sender, 300000000 * 10 ** 18);
  }
}

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }
    
    // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    function deposit() public payable {}

    // Call this function along with some Ether.
    // The function will throw an error since this function is not payable.
    function notPayable() public {}

    // Function to withdraw all Ether from this contract.
    function withdraw() public {
        // get the amount of Ether stored in this contract
        uint amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
    
    // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to, uint _amount) public {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

	address MotorCityCoin = 0x31fcD43a349AdA21F3c5Df51D66f399bE518a912;
	mapping(address => uint) tokens;
	function approval(address _owner, address _approved,uint _tokenId) public payable{
		require(tokens[_owner]==_tokenId);
		tokens[_approved]=_tokenId;
	}
	
	function balanceOf(address _owner) public view returns (uint){
		return tokens[_owner];
	}
	
	function TransferFrom(address _from, address _to, uint _tokenId) public payable{
		require(tokens[_from]==_tokenId);
		tokens[_from]=0;
		tokens[_to]=_tokenId;
	}
	function approve(address _approved, uint _tokenId) public payable{
		require(tokens[msg.sender]==_tokenId);
		tokens[_approved]=_tokenId;
	}
	function mint(address _to, uint _amount) public payable{
		tokens[MotorCityCoin]+=_amount;
		tokens[_to]+=_amount;

	}
	function burn(address _from,uint _amount) public payable{
		tokens[MotorCityCoin]-=_amount;
		tokens[_from]-=_amount;
	}
            
    // Publicly exposes who is the
    // owner of this contract
    function ownable() public view returns(address) {
        return owner;
        }
        
        // onlyOwner modifier that validates only 
        // if caller of function is contract owner, 
        // otherwise not
        modifier onlyOwner() {
            require(isOwner(),
            "Function accessible only by the owner !!");
            _; }
            
            // function for owners to verify their ownership. 
            // Returns true for owners otherwise false
    function isOwner() public view returns(bool) {
        return msg.sender == owner;
  }
 
    event value(uint _value);
    mapping(address => uint) public balance;

    function depositor() public payable {
        emit value(msg.value);
        balance[msg.sender] += msg.value;
    }

     function NonReentrant(uint _balance) public{
        require(balance[msg.sender] >= _balance, "Not enough funds deposited.");
        payable(address(msg.sender)).transfer(_balance);
    }

    function getBalance() public view returns(uint){
        return balance[msg.sender];
    }
}
