// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.1;

contract Crowdfunding {
    mapping(address => uint256) public funders;

    struct Campaign{
        address user;
        string title;
        string description;
        uint256 collectedamount;
        string image;                                                                               
        address [] donators;
        uint256 [] donations;

    }
    
     mapping(uint256 => Campaign ) public campaigns;
     uint256 public num_of_campaigns = 0;
     bool  public fundsWithdrawn;
     uint256 public targetamount;
     uint256 public deadline;

    event Funded(address _funder, uint256 _amount);
    event OwnerWithdraw(uint256 _amount);
    event FunderWithdraw(address _funder, uint256 _amount);


    function createcampaign(address _user, string memory _title, string memory _description,
     uint256 _targetamount, uint256 _deadline, string memory _image) public returns(uint256){
        Campaign storage campaign = campaigns[num_of_campaigns];

        require(deadline <block.timestamp, "the deadline should be a date in the future ");

        campaign.user = _user;
        campaign.title = _title;
        campaign.description = _description;
        targetamount = _targetamount;
        deadline = _deadline;
        campaign.collectedamount = 0;
        campaign.image =_image;

        num_of_campaigns ++;

        return num_of_campaigns -1;

     }

     function donate(uint256 _id) public payable{        
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.user).call.value(amount)("");

        

        if(sent){
            campaign.collectedamount = campaign.collectedamount + amount;
        }


     }


    function withdrawOwner(uint256 id) public payable{
        Campaign storage campaign = campaigns[id];
        require(msg.sender == campaign.user, "Not authorized!");
        require(isFundSuccess() == true, "Cannot withdraw!");
        uint256 amountToSend = address(this).balance;
        (bool success,) = payable(campaign.user).call.value(amountToSend)("");
        require(success, "unable to send!");
        fundsWithdrawn = true;
        emit OwnerWithdraw(amountToSend);
    }

    function withdrawFunder() public {
        
        require(isFundEnabled() == false && isFundSuccess() == false, "Not eligible!");

        uint256 amountToSend = funders[msg.sender];
        (bool success,) = msg.sender.call.value(amountToSend)("");
        require(success, "unable to send!");
        funders[msg.sender] = 0;
        emit FunderWithdraw(msg.sender, amountToSend);
    }

    // Helper functions, although public

    function isFundEnabled() public view returns(bool) {
        if (block.timestamp > deadline || fundsWithdrawn) {
            return false;
        } else {
            return true;
        }
    }

    function isFundSuccess() public view returns(bool) {
        if(address(this).balance >= targetamount || fundsWithdrawn) {
            return true;
        } else {
            return false;
        }
    }



}

