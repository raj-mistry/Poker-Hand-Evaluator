// CODED BY RAJ MISTRY ALONE
// SN 500896324
// CPS 506 RUST ASSIGNMENT


//TODO LIST
//GET WINNER LIST AND RETURN LIST OF STRING
//MAKE A DEAL METHOD


//-------------------------------FUNCTION DEAL------------------------------------------//
fn deal(deal: [u32;10])->[String;5]{
    let mut a = [deal[0],deal[2],deal[4],deal[6],deal[8]]; // a: [u32;5]
    let mut b = [deal[1],deal[3],deal[5],deal[7],deal[9]]; // a: [u32;5]

    let mut winner = [0,0,0,0,0];
    winner = get_betterhand(a,b);
    winner = sort_cards_asc(winner);
    return array_of_strings(winner);

}

//--------------------------------START OF MAIN FUNCTION--------------------------------//
/*
fn main(){
    /*
    let mut deal = [1,2,3,4,5,6,7,8,9,10];
    //let mut a = [deal[0],deal[2],deal[4],deal[6],deal[8]]; // a: [u32;5]
    //let mut b = [deal[1],deal[3],deal[5],deal[7],deal[9]]; // a: [u32;5]
    let mut a = [1,16,17,21,23];
    let mut b = [10,12,11,52,4];
    let mut winner = [0,0,0,0,0];
    winner = get_betterhand(a,b);
    print_array(winner);
    print_arraystring(array_of_strings(winner));
    print_arraystring(array_of_strings([1,2,3,4,5]));
    //println!("{}",check_fullhouse(a));
    //println!("{}",get_handrank(a));
    */
    let perm:[u32;10] = [1, 2, 14, 4, 13, 6, 27, 8, 40, 10];
    let winner:[String;5] = deal(perm);

    print_arraystring(winner);
}
*/
//----------------------------------END OF MAIN FUNCTION---------------------------------//


//----------------------------MAIN FUNCTION ASSISTANTS----------------------------------//

fn array_of_strings (a: [u32;5])->[String;5]{
    let club = String::from("C");
    let diamond = String::from("D");
    let heart = String::from("H");
    let spade = String::from("S");
    let mut arr: [String;5] = Default::default();
    for i in 0..5{
        let mut value = get_simplecard(a[i]);
        let mut suiteint=get_suite(a[i]);

        if suiteint==1{
            arr[i]=format!("{}{}",value,club);
        }
        else if suiteint==2{
            arr[i]=format!("{}{}",value,diamond);
        }
        else if suiteint==3{
            arr[i]=format!("{}{}",value,heart);
        }
        else if suiteint==4{
            arr[i]=format!("{}{}",value,spade);
        }
    }
    return arr;
}

//START OF GET BETTER HAND
fn get_betterhand(a: [u32;5], b: [u32;5])-> [u32;5]{
    let mut winner = 0;
    let a_handrank = get_handrank(a);
    let b_handrank = get_handrank(b);

    if a_handrank>b_handrank{
        winner = 1;
    }
    else if a_handrank<b_handrank{
        winner = 2;
    }
    else{//tie break
        winner = tiebreaker(a,b,a_handrank);
    }
    if winner==1{
        return a;
    }
    else if winner==2{
        return b;
    }
    else{
        return [0,0,0,0,0];
    }
}
//END OF GET BETTER HAND

//START OF TIE BREAKER CALLER
fn tiebreaker(a: [u32;5], b: [u32;5],rank: u32)-> u32{
    if rank==10{
        return tiebreaker_royalflush(a,b);
    }
    else if rank==9{
        return tiebreaker_straightflush(a,b);
    }
    else if rank==8{
        return tiebreaker_fourofakind(a,b);
    }
    else if rank==7{
        return tiebreaker_fullhouse(a,b);
    }
    else if rank==6{
        return tiebreaker_flush(a,b);
    }
    else if rank==5{
        return tiebreaker_straight(a,b);
    }
    else if rank==4{
        return tiebreaker_threeofakind(a,b);
    }
    else if rank==3{
        return tiebreaker_twopair(a,b);
    }
    else if rank==2{
        return tiebreaker_pair(a,b);
    }
    else if rank==1{
        return tiebreaker_highcard(a,b);
    }
    else{
        return 0;
    }
}
//END OF TIE BREAKER CALLER

//START OF HANDRANKER
fn get_handrank(mut a: [u32;5])-> u32{
    let mut handrank=1; //Default High Card
    if check_royalflush(a)==true{
        handrank=10;
    }
    else if check_straightflush(a)==true{
        handrank=9;
    }
    else if check_fourofakind(a)==true{
        handrank=8;
    }
    else if check_fullhouse(a)==true{
        handrank=7;
    }
    else if check_flush(a)==true{
        handrank=6;
    }
    else if check_straight(a)==true{
        handrank=5;
    }
    else if check_threeofakind(a)==true{
        handrank=4;
    }
    else if check_twopair(a)==true{
        handrank=3;
    }
    else if check_pair(a)==true{
        handrank=2;
    }
    return handrank;
}
//END OF HANDRANKER

//------------------------------END OF MAIN FUNCTION ASSISTANTS-------------------------//



//-------------------------START OF ESSENTIAL FUNCTIONS--------------------------------//

//START OF GET SUITE
fn get_suite(a: u32)-> u32{// WORKS
    if a<14 { 
        return 1;
    }
    if a<27 { 
        return 2;
    }
    if a<40 { 
        return 3;
    }
    if a<53 { 
        return 4;
    }
    return 0;
}
//END OF GET SUITE

//START OF GET SIMPLE CARD
fn get_simplecard(mut a: u32)->u32{
    a = ((a-1)%13)+1;
    return a;
}
//END OF GET SIMPLE CARD

//START OF SIMPLIFY ARRAY - WORKS
fn simplify_array(mut a: [u32;5])-> [u32; 5]{
    for i in 0..5 {
        a[i] = ((a[i]-1)%13)+1;
    }
    return a;
}
//END OF SIMPLIFY ARRAY

//START OF SORT CARDS DESCENDING BY NUMBER (ACE NOT ACCOMODATED) RETAINS SUITE (0-52)
fn sort_cards_desc(mut a: [u32;5])-> [u32;5]{ //does not simplify cards, sorts them in descending order first by rank and then by suite
    let mut sorted = false;
    while sorted==false {
        sorted = true;
        for i in 1..5{
            if get_simplecard(a[i-1])<get_simplecard(a[i]){
                let temp = a[i-1];
                a[i-1]=a[i];
                a[i]=temp;
                sorted = false;
            }
            else if get_simplecard(a[i-1])==get_simplecard(a[i]){
                if a[i-1]<a[i]{
                    let temp = a[i-1];
                    a[i-1]=a[i];
                    a[i]=temp;
                    sorted = false;
                }
            }
        }
    }
    return a;
}
//END OF SORT CARDS DESCENDING BY NUMBER (ACE NOT ACCOMODATED) RETAINS SUITE (0-52)

//START OF SORT CARDS ASCENDING BY NUMBER (ACE NOT ACCOMODATED) RETAINS SUITE (0-52)
fn sort_cards_asc(mut a: [u32;5])-> [u32;5]{ //does not simplify cards, sorts them in descending order first by rank and then by suite
    let mut sorted = false;
    while sorted==false {
        sorted = true;
        for i in 1..5{
            if get_simplecard(a[i-1])>get_simplecard(a[i]){
                let temp = a[i-1];
                a[i-1]=a[i];
                a[i]=temp;
                sorted = false;
            }
            else if get_simplecard(a[i-1])==get_simplecard(a[i]){
                if a[i-1]>a[i]{
                    let temp = a[i-1];
                    a[i-1]=a[i];
                    a[i]=temp;
                    sorted = false;
                }
            }
        }

    }
    return a;
}
//END OF SORT CARDS ASCENDING BY NUMBER (ACE NOT ACCOMODATED) RETAINS SUITE (0-52)

//-------------------------------END OF ESSENTIAL FUNCTIONS-----------------------------------//


//--------------------------START OF TIE BREAKERS---------------------------//

//START OF TIE BREAKER FOR ROYAL FLUSH
fn tiebreaker_royalflush(a: [u32;5],b: [u32;5])->u32{ //DONE
    if get_suite(a[0])>get_suite(b[0]){
        return 1;
    }
    return 2;
}
//END OF TIE BREAKER FOR ROYALFLUSH

//START OF TIE BREAKER FOR STRAIGHT FLUSH
fn tiebreaker_straightflush(a: [u32;5],b: [u32;5])->u32{
    return tiebreaker_straight(a,b);
}
//END OF TIE BREAKER FOR STRAIGHT FLUSH

//START OF TIE BREAKER FOR FOUR OF A KIND
fn tiebreaker_fourofakind(mut a: [u32;5],mut b: [u32;5])->u32{
    return tiebreaker_fullhouse(a,b);
}
//END OF TIE BREAKER FOR FOUR OF A KIND

//START OF TIE BREAKER FOR FULL HOUSE
fn tiebreaker_fullhouse(mut a: [u32;5],mut b: [u32;5])->u32{
    a = simplify_array(a);
    b = simplify_array(b);
    a.sort();
    b.sort();

    if get_betterrank(a[2],b[2])!=0{
        return get_betterrank(a[2],b[2]);
    }
    else{
        return 0;
    }
}
//END OF TIE BREAKER FOR FULL HOUSE

//START OF TIE BREAKER FOR FLUSH
fn tiebreaker_flush(a: [u32;5],b: [u32;5])->u32{
    if get_suite(a[0])>get_suite(b[0]){
        return 1;
    }
    else if get_suite(a[0])<get_suite(b[0]){
        return 2;
    }
    else{ //same flush, check high card
        return tiebreaker_highcard(a,b);
    }
}
//END OF TIE BREAKER FOR FLUSH

//START OF TIE BREAKER FOR STRAIGHT
fn tiebreaker_straight(mut a: [u32;5],mut b: [u32;5])->u32{ //DONE
    a = sort_cards_asc(a);
    b = sort_cards_asc(b);
    //tie breaking for ace

    let a_first = get_simplecard(a[0]);
    let a_last = get_simplecard(a[4]);
    let b_first = get_simplecard(b[0]);
    let b_last = get_simplecard(b[4]);

    if a_first==1&&a_last==13||b_first==1&&b_last==13{ //tie breaking with aces
        if a_first==1&&b_first!=1{
            return 1;
        }
        else if a_first!=1 && b_first==1{
            return 2;
        }
        else{ //tied, need suite
            if get_suite(a[0])>get_suite(b[0]){
                return 1;
            }
            else{
                return 2;
            }  
        }    
    }
    else{ //tie breaking without aces
        if a_last>b_last{
            return 1;
        }
        else if a_last<b_last{
            return 2;
        }
        else{
            if get_suite(a[4])>get_suite(b[4]){
                return 1;
            }
            else{
                return 2;
            } 
        }
    }
}
//END OF TIE BREAKER FOR STRAIGHT

//START OF TIE BREAKER THREE OF A KIND
fn tiebreaker_threeofakind(a: [u32;5],b: [u32;5])->u32{
    return tiebreaker_fullhouse(a,b);
}
//END OF TIE BREAKER THREE OF A KIND

//START OF TIE BREAKER TWO PAIR
fn tiebreaker_twopair(mut a: [u32;5],mut b: [u32;5])->u32{

    a = sort_cards_desc(a);
    b = sort_cards_desc(b);

    let mut a_simple = simplify_array(a);
    let mut b_simple = simplify_array(b);

    let mut a_pair1 = [0,0];
    let mut a_pair2 = [0,0];
    let mut a_single_card = 0;

    let mut b_pair1 = [0,0];
    let mut b_pair2 = [0,0];
    let mut b_single_card = 0;


    //setup for a
    if a_simple[0]==a_simple[1]{ //first 2 are pair
        a_pair1 = [a[0],a[1]];
        if a_simple[2]==a_simple[3]{ //next 2 are pair
            a_pair2 = [a[2],a[3]];
            a_single_card=a[4]; //then the last card is single
        }
        else{ //last 2 are pair
            a_pair2 = [a[3],a[4]];
            a_single_card=a[2];
        }
    }
    else{//first card is single
        a_single_card = a[0];
        a_pair1 = [a[1],a[2]];
        a_pair2 = [a[3],a[4]];
    }

    //setup for a
    if a_simple[0]==a_simple[1]{ //first 2 are pair
        a_pair1 = [a[0],a[1]];
        if a_simple[2]==a_simple[3]{ //next 2 are pair
            a_pair2 = [a[2],a[3]];
            a_single_card=a[4]; //then the last card is single
        }
        else{ //last 2 are pair
            a_pair2 = [a[3],a[4]];
            a_single_card=a[2];
        }
    }
    else{//first card is single
        a_single_card = a[0];
        a_pair1 = [a[1],a[2]];
        a_pair2 = [a[3],a[4]];
    }


    //setup for b
    if b_simple[0]==b_simple[1]{ //first 2 are pair
        b_pair1 = [b[0],b[1]];
        if b_simple[2]==b_simple[3]{ //next 2 are pair
            b_pair2 = [b[2],b[3]];
            b_single_card=b[4]; //then the last card is single
        }
        else{ //last 2 are pair
            b_pair2 = [b[3],b[4]];
            b_single_card=b[2];
        }
    }
    else{//first card is single
        b_single_card = b[0];
        b_pair1 = [b[1],b[2]];
        b_pair2 = [b[3],b[4]];
    }

    //to accomodate aces, if pair2 contains ace, swap
    //for a
    if get_simplecard(a_pair2[0])==1{
        let temp = a_pair1;
        a_pair1 = a_pair2;
        a_pair2 = temp;
    }
    //for b
    if get_simplecard(b_pair2[0])==1{
        let temp = b_pair1;
        b_pair1 = b_pair2;
        b_pair2 = temp;
    }

    //first we check the best pairs of each hand
    if get_betterrank(a_pair1[0],b_pair1[0])==0{
        if get_betterrank(a_pair2[0],b_pair2[0])==0{
            if get_betterrank(a_single_card,b_single_card)==0{
                //if it reaches this stage, we must tie break with high card check
            }
            else{
                return get_betterrank(a_single_card,b_single_card);
            }
        }
        else{
            return get_betterrank(a_pair2[0],b_pair2[0]);
        }
    }
    else{
        return get_betterrank(a_pair1[0],b_pair1[0]);
    }

    return 0;
}
//END OF TIE BREAKER TWO PAIR

//START OF GET BETTER CARD
//returns the better rank, accomodates aces, and returns 
//better suite if ranks are the same (takes 2 single cards)
fn get_bettercard(a: u32, b: u32)->u32{
    let a_simplevalue = get_simplecard(a);
    let b_simplevalue = get_simplecard(b);
    let a_suite = get_suite(a);
    let b_suite = get_suite(b);

    //for aces

    if a_simplevalue==1||b_simplevalue==1{
        if b_simplevalue!=1{
            return 1;
        }
        else if a_simplevalue!=1{
            return 2;
        }
        else{
            if a_suite>b_suite{
                return 1;
            }
            else{
                return 2;
            }
        }
    }
    //for everything else
    else{
        if a_simplevalue>b_simplevalue{
            return 1;
        }
        else if a_simplevalue<b_simplevalue{
            return 2;
        }
        else{
            if a_suite>b_suite{
                return 1;
            }
            else{
                return 2;
            }
        }
    }
}
//END OF GET BETTER CARD

//START OF GET BETTER RANK 
//returns the better rank, accomodates aces, and returns 0 if ranks are the same (takes 2 single cards)
fn get_betterrank(a: u32, b: u32)->u32{
    let a_simplevalue = get_simplecard(a);
    let b_simplevalue = get_simplecard(b);

    //for aces

    if a_simplevalue==1||b_simplevalue==1{
        if b_simplevalue!=1{
            return 1;
        }
        else if a_simplevalue!=1{
            return 2;
        }
        else{
            return 0;
        }
    }
    //for everything else
    else{
        if a_simplevalue>b_simplevalue{
            return 1;
        }
        else if a_simplevalue<b_simplevalue{
            return 2;
        }
        else{
            return 0;
        }
    }
}
//END OF GET BETTER RANK

//START OF PAIR TIE BREAKER
fn tiebreaker_pair(mut a: [u32;5],mut b: [u32;5])->u32{
    a = sort_cards_desc(a);
    b = sort_cards_desc(b);

    let a_simple = simplify_array(a);
    let b_simple = simplify_array(b);

    let mut a_pair = [0,0];
    let mut a_rest = [0,0,0];

    let mut b_pair = [0,0];
    let mut b_rest = [0,0,0];

    //setup for a

    if a_simple[0]==a_simple[1]{
        a_pair = [a[0],a[1]];
        a_rest = [a[2],a[3],a[4]];
    }
    else if a_simple[1]==a_simple[2]{
        a_pair = [a[1],a[2]];
        a_rest = [a[0],a[3],a[4]];
    }
    else if a_simple[2]==a_simple[3]{
        a_pair = [a[2],a[3]];
        a_rest = [a[0],a[1],a[4]];
    }
    else if a_simple[3]==a_simple[4]{
        a_pair = [a[3],a[4]];
        a_rest = [a[0],a[1],a[2]];
    }


    //setup for b

    if b_simple[0]==b_simple[1]{
        b_pair = [b[0],b[1]];
        b_rest = [b[2],b[3],b[4]];
    }
    else if b_simple[1]==b_simple[2]{
        b_pair = [b[1],b[2]];
        b_rest = [b[0],b[3],b[4]];
    }
    else if b_simple[2]==b_simple[3]{
        b_pair = [b[2],b[3]];
        b_rest = [b[0],b[1],b[4]];
    }
    else if b_simple[3]==b_simple[4]{
        b_pair = [b[3],b[4]];
        b_rest = [b[0],b[1],b[2]];
    }

    if get_betterrank_3(a_rest,b_rest)==0{
        //high card checker
        return tiebreaker_highcard(a,b);
    }
    else{
        return get_betterrank_3(a_rest,b_rest);
    }
}
//END OF PAIR TIE BREAKER

// START OF SPECIALIZED FUNCTIONS
fn simplify_array_3(mut a: [u32;3])-> [u32; 3]{
    for i in 0..3 {
        a[i] = ((a[i]-1)%13)+1;
    }
    return a;
}

fn sort_cards_desc_3(mut a: [u32;3])-> [u32;3]{ //does not simplify cards, sorts them in descending order first by rank and then by suite
    let mut sorted = false;
    while sorted==false {
        sorted = true;
        for i in 1..3{
            if get_simplecard(a[i-1])<get_simplecard(a[i]){
                let temp = a[i-1];
                a[i-1]=a[i];
                a[i]=temp;
                sorted = false;
            }
            else if get_simplecard(a[i-1])==get_simplecard(a[i]){
                if a[i-1]<a[i]{
                    let temp = a[i-1];
                    a[i-1]=a[i];
                    a[i]=temp;
                    sorted = false;
                }
            }
        }

    }
    return a;
}

fn sort_cards_asc_3(mut a: [u32;3])-> [u32;3]{ //does not simplify cards, sorts them in descending order first by rank and then by suite
    let mut sorted = false;
    while sorted==false {
        sorted = true;
        for i in 1..3{
            if get_simplecard(a[i-1])>get_simplecard(a[i]){
                let temp = a[i-1];
                a[i-1]=a[i];
                a[i]=temp;
                sorted = false;
            }
            else if get_simplecard(a[i-1])==get_simplecard(a[i]){
                if a[i-1]>a[i]{
                    let temp = a[i-1];
                    a[i-1]=a[i];
                    a[i]=temp;
                    sorted = false;
                }
            }
        }

    }
    return a;
}

fn get_betterrank_3(mut a: [u32;3],mut b: [u32;3])-> u32{
    a = sort_cards_desc_3(a);
    b = sort_cards_desc_3(b);
    let a_simple = simplify_array_3(a);
    let b_simple = simplify_array_3(b);


    if a_simple[2]==1||b_simple[2]==1{
        //if ace exists in this
        if a_simple[2]!=1{
            return 2;
        }
        else if b_simple[2]!=1{
            return 1;
        }
        else{
            //both have ace, move on.

            if a_simple[0]>b_simple[0]{
                return 1;
            }
            else if a_simple[0]<b_simple[0]{
                return 2;
            }
            else{
                //first element is equal
                if a_simple[1]>b_simple[1]{
                    return 1;
                }
                else if a_simple[1]<b_simple[1]{
                    return 2;
                }
                else{
                    return 0; //high card checker
                }
            }
        }

    }
    else{
        //for everything else
        if a_simple[0]>b_simple[0]{
            return 1;
        }
        else if a_simple[0]<b_simple[0]{
            return 2;
        }
        else{
            //first element the same
            if a_simple[1]>b_simple[1]{
                return 1;
            }
            else if a_simple[1]<b_simple[1]{
                return 2;
            }
            else{
                //second element the same
                if a_simple[2]>b_simple[2]{
                    return 1;
                }
                else if a_simple[2]<b_simple[2]{
                    return 2;
                }
                else{
                    return 0; //check high card third element the same
                }
                
            }
        }
    }
}
//END OF SPECIALIZED FUNCTIONS

//START OF HIGH CARD CHECKER
fn tiebreaker_highcard(mut a: [u32;5],mut b: [u32;5])->u32{
    //for no aces assuming stuffs in descending order
    //NEED TO FINISH IMPLEMENTATION FOR ACES

    a = sort_cards_desc(a);
    b = sort_cards_desc(b);
    let mut ace = false;
    let mut highestace_a = 0;
    let mut highestace_b = 0;
    if get_simplecard(a[4])==1 || get_simplecard(b[4])==1{
        ace = true;
        for i in 0..5{
            if get_simplecard(a[4-i])==1 || get_simplecard(b[4-i])==1{
                highestace_a=4-i;
                highestace_b=4-i;
                if get_betterrank(a[4-i],b[4-i])!=0{
                    return get_betterrank(a[4-i],b[4-i]);
                }
            }
        }
    }
    for i in 0..5{
        if get_betterrank(a[i],b[i])!=0{
            return get_betterrank(a[i],b[i]);
        }
    }
    //if it reaches here, all cards same rank return high suite of highest card.
    if ace==true{
        return get_bettercard(a[highestace_a],b[highestace_b]);
    }
    else{
    return get_bettercard(a[0],b[0]);
    }
}
//END OF HIGH CARD CHECKER

//-------------------------END OF TIE BREAKERS--------------------------------------------------//


//-------------------------START OF THE CHECK METHODS--------------------------------------------------//


//START OF PRINT FUNCTION - WORKS
fn print_array(a: [u32;5]){
    println!("{0},{1},{2},{3},{4}",a[0],a[1],a[2],a[3],a[4]);
}

fn print_arraystring(a: [String;5]){
    println!("{0},{1},{2},{3},{4}",a[0],a[1],a[2],a[3],a[4]);
}
//END OF PRINT FUNCTION

//START OF FLUSH CHECKER
fn check_flush(a:[u32;5])-> bool{
    let mut flush = true;
    let suite = get_suite(a[0]);
    for i in 1..5{
        if suite!=get_suite(a[i]){
            flush=false;
        }
    }
    return flush;
}
//END OF FLUSH CHECKER

//START OF STRAIGHT CHECKER - WORKING
fn check_straight(mut a: [u32;5])-> bool{
    a = simplify_array(a); //MUST EXECUTE BEFORE SORTING.
    a.sort();
    let mut straight=true;
    for i in 1..5 {
        if a[i]!=a[i-1]+1{
            if (a[i]==10&&a[i-1]==1){
            }
            else{
                straight=false;
            }
        }
    }
    return straight;
}
//END OF STRAIGHT CHECKER

//START OF STRAIGHT FLUSH CHECK
fn check_straightflush(a: [u32;5])-> bool{
    if check_straight(a)==true && check_flush(a)==true{
        return true;
    }
    return false;
}
//END OF STRAIGHT FLUSH CHECK

//START OF ROYAL FLUSH CHECK - WORKS
fn check_royalflush(a: [u32;5])-> bool{
    let mut b = simplify_array(a);
    b.sort();
    if b==[1,10,11,12,13]&&check_flush(a)==true{
        return true;
    }
    return false;
}
//END OF ROYAL FLUSH CHECK

//CHECK 4 OF A KIND - WORKS
fn check_fourofakind(a: [u32;5])-> bool{
    let mut fourofakind=false;

    let mut b = a;
    b = simplify_array(b);
    b.sort();
    let mut first=b[0];
    let mut last=b[4];
    if ((b[0]==b[1] && b[0]==b[2] && b[0]==b[3]) || (b[4]==b[1] && b[4]==b[2] && b[4]==b[3])){ //checking to see if the first 4 or last 4 are equal
        fourofakind=true;
    }
    return fourofakind;
}
//END OF CHECK 4 OF A KIND

//CHECK 3 OF A KIND - WORKS
fn check_threeofakind(a: [u32;5])-> bool{
    let mut threeofakind=false;
    let mut b = a;
    b = simplify_array(b);
    b.sort();
    if (b[0]==b[1]&&b[0]==b[2])||(b[1]==b[2]&&b[1]==b[3])||(b[2]==b[3]&&b[2]==b[4]){ //checking to see if the first 3, mid 3, or last 3 are equal
        threeofakind=true;
    }
    return threeofakind;
}
//END OF CHECK 3 OF A KIND

//CHECK PAIR - WORKS
fn check_pair(a: [u32;5])-> bool{
    let mut pair=false;
    let mut b = a;
    b = simplify_array(b);
    b.sort();
    if (b[0]==b[1]||b[1]==b[2]||b[2]==b[3]||b[3]==b[4]){ 
        pair=true;
    }
    return pair;
}
//END OF CHECK PAIR

//CHECK FULLHOUSE - WORKS
fn check_fullhouse(a: [u32;5])-> bool{
    let mut fullhouse=false;
    let mut b = a;
    b = simplify_array(b);
    b.sort();
    if (b[0]==b[1]&&(b[2]==b[3]&&b[2]==b[4]&&b[2]!=b[0]))||((b[0]==b[1]&&b[0]==b[2])&&b[3]==b[4]&&b[3]!=b[0]){//First 2 and last 3 are same or first 3 and last 2 are same 
        fullhouse=true;
    }
    return fullhouse;
}
//END OF CHECK FULLHOUSE

//CHECK TWO PAIR - WORKS
fn check_twopair(a: [u32;5])-> bool{
    let mut twopair=false;
    let mut b = a;
    b = simplify_array(b);
    b.sort();
    if (b[0]==b[1]&&b[3]==b[4]&&b[3]!=b[0]) || (b[0]==b[1]&&b[2]==b[3]&&b[2]!=b[0]) || (b[1]==b[2]&&b[3]==b[4]&&b[1]!=b[3]){//First 2 and last 2, or first 2 and next2, or last 2 and prev 2.
        twopair=true;
    }
    return twopair;
}
//END OF CHECK TWO PAIR

//-------------------------END OF THE CHECK METHODS--------------------------------------------------//