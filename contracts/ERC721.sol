pragma solidity >=0.4.22 <0.9.0;

contract ERC721 {
    // EVENTS

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    event newSailor(uint256 sailorId, string name, string color);

    // NFT struct

    struct SailorMoon {
        string name;
        string color;
    }

    // Declaring the array that contains the items
    SailorMoon[] public sailorSenshies;

    //Mappings

    mapping(uint256 => address) public owner; // mapping points to owner

    mapping(address => uint256) howManyItems; // mapping points to how many items does an addres owns

    mapping(uint256 => address) private tokenApprovals; // mapping from token ID to approved address

    mapping(address => mapping(address => bool)) private operatorApprovals; // mapping from owner to operator approvals

    mapping(uint256 => bool) public tokenExist;

    // creating our unique item
    function createSailorMoon(string memory _name, string memory _color)
        public
    {
        sailorSenshies.push(SailorMoon(_name, _color));
        uint256 _tokenId = sailorSenshies.length - 1;
        emit newSailor(_tokenId, _name, _color);
    }

    // check if it exists already
    function _tokenExist(uint256 _tokenId) public view returns (bool) {
        return owner[_tokenId] != address(0);
    }

    // Non-modifying functions
    function balanceOf(address _owner) public view returns (uint256) {
        return howManyItems[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return owner[_tokenId];
    }

    function getAllSailors() public view returns (uint256 allItems) {
        return sailorSenshies.length;
    }

    function getApproved(uint256 _tokenId)
        external
        view
        returns (address operator)
    {
        return tokenApprovals[_tokenId];
    }

    // Modifying functions
    function transfer(address _to, uint256 _tokenId)
        external
        returns (bool success)
    {
        require(_to != address(0), "Transfer to zero address is not possible");
        require(_to != address(this), "You cannot send to youself");
        require(isOwner(msg.sender, _tokenId));

        transferFrom(msg.sender, _to, _tokenId);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable returns (bool success) {
        require(
            owner[_tokenId] == _from,
            "Cannot transfer, token is not owned"
        );

        owner[_tokenId] = _to;
        howManyItems[_to]++;

        howManyItems[_from]--;
        emit Transfer(_from, _to, _tokenId);

        return true;
    }

    function approve(address _to, uint256 _tokenId) external {
        tokenApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved)
        external
        view
    {
        operatorApprovals[_operator];
        _approved == true;
    }

    function mint(address _to, uint256 _tokenId) external {
        require(_to != address(0), "ERC721: mint to the zero address");
        require(!_tokenExist(_tokenId), "ERC721: token already minted");

        howManyItems[_to] += 1;
        owner[_tokenId] = _to;

        emit Transfer(msg.sender, _to, _tokenId);
    }

    function isOwner(address _claimant, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        return owner[_tokenId] == _claimant;
    }
}
