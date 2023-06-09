pragma solidity ^0.4.25;

    
contract VoteMain {
   

    struct  Counter {  //计票者
        address wallet;
        int reputation;
        uint money;
        string state;
        uint[] result;
    }
    
   struct Voter{   //投票者 
       address ID;
       string Ring_PKx;
       string Ring_PKy;
       string f_ix;
       string f_iy;
       string s_i;
   }
   
   struct Ballot{
       string ticket;
       string RS;
   }

   uint Num;  //证人委员会人数
   uint fine;  //罚款
   uint revenue;  //奖金
   string Topic;
   string time_register;
   string time_f;
   string time_s;
   string time_finish_vote;
   string time_finish_count;
   string G;
   string[] F_Ix;
   string[] F_Iy;
   string[] S_I;
   string PublicKey_x;
   string PublicKey_y;
   string PrivateKey;
   
   uint seed;
   uint[] RESULT;
 
  
   Voter[] voters;
   Ballot[] ballots;
   
   
   function setKey(string pkx,string pky,string x)public{
       PublicKey_x=pkx;
       PublicKey_y=pky;
       PrivateKey=x;
   }
   
   function getPublicKey()public view returns(string,string){
       return(PublicKey_x,PublicKey_y);
   }
   
   function getPrivateKey() public view returns(string){
       return(PrivateKey);
   }
   function submitBallot(string TICKET,string Sign)public{
       Ballot t;
       t.ticket=TICKET;
       t.RS=Sign;
       ballots.push(t);
   }
   
   function getBallot(uint n)public view returns(string,string){
       Ballot t=ballots[n-1];
       return(t.ticket,t.RS);
   }
   
   function setConfig(uint num,uint f,uint r,string topic,string t_r,string t_f,string t_f_v,string t_s,string t_f_c,string g)public{
      if (msg.sender==0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
      {Num=num;
       fine=f;
       revenue=r;
       Topic=topic;
       time_register=t_r;
       time_f=t_f;
       time_s=t_s;
       time_finish_vote=t_f_v;
       time_finish_count=t_f_c;
       G=g;
      }
   }
   
   function initiateVoter(string ringpkx,string ringpky)public returns(bool){
       for(uint i=0;i<voters.length;i++)
       {
           if(voters[i].ID==msg.sender)
           return false;
       }
       Voter t;
       t.ID=msg.sender;
       t.Ring_PKx=ringpkx;
       t.Ring_PKy=ringpky;
       voters.push(t);
       return true;
   }
   
   function setF_i(string fix,string fiy)public returns(bool){
       for(uint i=0;i<voters.length;i++){
           if(voters[i].ID==msg.sender)
           {
               voters[i].f_ix=fix;
               voters[i].f_iy=fiy;
               F_Ix.push(fix);
               F_Iy.push(fiy);
               return true;
           }
       }
       return false;
   }
   
   function setS_i(string si)public returns(bool){
       for(uint i=0;i<voters.length;i++){
           if(voters[i].ID==msg.sender)
           {
               voters[i].s_i=si;
               S_I.push(si);
               return true;
           }
       }
       return false;
   }
   
   
   function getF_i(uint n)public view returns(string,string){
       return(F_Ix[n-1],F_Iy[n-1]);
   }
   
   function getS_i(uint n)public view returns(string){
       return(S_I[n-1]);
   }
   

   
   function getCounterConfig()public view returns(uint,uint,uint,string,string,string){
       return(Num,fine,revenue,time_s,time_finish_count,G);
   }
   
   function getVoterConfig()public view returns(string,string,string,string,string,string){
       return (Topic,time_register,time_f,time_finish_vote,time_s,G);
   }
   

   function setResult(uint[] rs)public{
       for(uint i=0;i<rs.length;i++)
       {
           RESULT.push(rs[i]);
       }
   }
   
    function getResult()public view returns(uint[]){
       return(RESULT);
    }

   
   Counter[] public counterPool;
   Counter[] public counterOnline;
   
   
   
   Counter[] public counterCommittee;
   Counter[] public counterPunish;
   Counter[] public counterAward;
   


   
   
   function printCounter(string which,uint index)public view returns(address,int,uint,string,uint[]){
     
     
       Counter t;
       if(keccak256(which) == keccak256("Pool"))
       {
           t=counterPool[index-1];
      
       }
       else if(keccak256(which) == keccak256("Online"))
       {
            t=counterOnline[index-1];
        }
        else if(keccak256(which) == keccak256("Committee"))
        {
            t=counterCommittee[index-1];
        }
        else if(keccak256(which) == keccak256("Punish"))
        {
            t=counterPunish[index-1];
        }
        else if(keccak256(which) == keccak256("Award"))
        {
            t=counterAward[index-1];
        }
   
         return(t.wallet,t.reputation,t.money,t.state,t.result);
   }
   
   
   function printVoter(uint n)public view returns(address,string,string){
       Voter t=voters[n-1];
       return(t.ID,t.Ring_PKx,t.Ring_PKy);
   }
   
  
   
   function initiateCounter(string state)public returns(bool){

       for(uint i=0;i<counterPool.length;i++)
       {
           if(counterPool[i].wallet==msg.sender)
           return false;
       }
       Counter c;
       c.wallet=msg.sender;
       c.state=state;
       c.money=10;
       counterPool.push(c);
       return true;
   }
   
   
   function setState(string state)public  returns(bool){
       
       if(keccak256(state) != keccak256("Online")&&keccak256(state) != keccak256("Offline"))
       return false;
       
       for(uint i=0;i<counterPool.length;i++){
           if(counterPool[i].wallet==msg.sender)
           {
               counterPool[i].state=state;
               return true;
           }
       }
       
       return false;
   }
   
   
   function setCounter_Result(uint[] r)public  returns(bool){
       
       
       
       for(uint i=0;i<counterCommittee.length;i++){
           if(counterCommittee[i].wallet==msg.sender)
           {
               counterCommittee[i].result=r;
               return true;
           }
       }
       
       return false;
   }
   
   function setCounterOnline()public {
       counterOnline.length=0;
       for(uint i=0;i<counterPool.length;i++){
           if(keccak256(counterPool[i].state) == keccak256("Online")){
               counterOnline.push(counterPool[i]);
           }
       }
       
   }
   
   
   
  

   

    
    function InitiateSeed()internal  returns (uint) {
       seed= uint(keccak256(block.timestamp, block.difficulty));
       return seed;
   }
  
 
   function RandomSelect()public{
       uint i=0;
       InitiateSeed();

       uint oc=counterOnline.length;
       while(i<Num){
           seed %= oc;
           
           if(keccak256(counterOnline[i].state) == keccak256("Online")&&counterOnline[i].reputation>=0
           &&counterOnline[i].money>=fine)
           {
               
               counterOnline[i].state="Candidate";
               oc--;
            
             
               counterCommittee.push(counterOnline[i]);
               
               i++;
           }

       
          seed=uint(keccak256(toAscii(seed)));

       }
       
       

   }
   
   function toAscii(uint256 x) public pure returns (string) {
        bytes memory b = new bytes(32);
        for(uint256 i = 0; x > 0; i++) {
            b[i] = byte((x % 10) + 0x30);
            x /= 10;
        }
        bytes memory r = new bytes(i--);
        for(uint j = 0; j < r.length; j++) {
            r[j] = b[i--];
        }
        return string(r);
    }


    
     function Payoff() public   {
        uint i;
        
        for(i=0;i<counterCommittee.length;i++){
            Counter t=counterCommittee[i];
            
            uint flag=0;
            
            if(t.result.length!=RESULT.length)
               flag=1;
    
                
            
            else{
                for(uint j=0;j<RESULT.length;j++){
                    if(t.result[j]!=RESULT[j])
                    {
                        flag=1;
                        break;
                    }
                }
            }
            
            if (flag==0)
                { counterAward.push(t);}
            else
                 {counterPunish.push(t);}
        }
       
        for( i=0; i<counterPunish.length; i++){
           counterPunish[i].reputation-=2;
           counterPunish[i].money-=fine;
        }
        for(i=0; i<counterAward.length; i++){
           counterAward[i].reputation+=1;
           counterAward[i].money+=revenue;
        }
    }
    
}



