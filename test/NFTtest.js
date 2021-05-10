const ERC721 = artifacts.require("ERC721");
const truffleAssert = require("truffle-assertions");

contract("ERC721", (accounts) => {
  it("should deploy successfully", async () => {
    const nft = await ERC721.deployed();
    console.log("contract address", nft.address);
    await truffleAssert.passes(nft.address != "");
  });

  it(" tokens should not exist before creation", async () => {
    const nft = await ERC721.deployed();
    const getAllSailors = await nft.getAllSailors();
    assert.equal(getAllSailors, 0);

    await truffleAssert.passes(nft.getAllSailors());
  });

  it("should create tokens", async () => {
    const nft = await ERC721.deployed();

    await nft.createSailorMoon("Sailor Pluto", "dark green");
    await nft.createSailorMoon("Sailor Neptune", "Turquoise");
    await nft.createSailorMoon("Sailor Moon", "pink");

    const getAllSailors = await nft.getAllSailors();

    let sailorSenshi;
    const result = [];

    for (let i = 1; i <= getAllSailors; i++) {
      sailorSenshi = await nft.sailorSenshies(i - 1);
      result.push(sailorSenshi);
    }

    let expectedResult = [
      {
        name: "Sailor Pluto",
        color: "dark green",
      },
      {
        name: "Sailor Neptune",
        color: "Turquoise",
      },
      {
        name: "Sailor Moon",
        color: "pink",
      },
    ];

    assert.equal(result, expectedResult);
    assert.equal(getAllSailors, 3);
  });

  it("should mint tokens to given address", async () => {
    const nft = await ERC721.deployed();
    // assinging tokens to account 1
    nft.mint(accounts[1], 3);
    nft.mint(accounts[1], 1);
    nft.mint(accounts[1], 2);

    await truffleAssert.passes(nft.mint(accounts[1], 0));
  });

  it("should revert transfer if item is not owned by account", async () => {
    const nft = await ERC721.deployed();

    await nft.approve(accounts[2], 0);

    await truffleAssert.reverts(nft.transferFrom(accounts[0], accounts[2], 0));
    await truffleAssert.reverts(nft.transfer(accounts[2], 0));
  });

  it("should approve all accounts", async () => {
    const nft = await ERC721.deployed();

    await nft.setApprovalForAll(accounts[3], true);

    await truffleAssert.passes(nft.approve(accounts[3], 1));
  });
});
