# CODE BY RAJ MISTRY
# STUDENT NUMBER: 500896324
# ALL CODED BY ME ALONE.



#Notes for development:
#We have a high card checker/suite checker when theres similar hands, flush checker, straight checker

#Hands:

#10) Royal Flush - DONE
#9) Straight Flush - DONE
#8) Four of a Kind - DONE
#7) Full House - DONE
#6) Flush - DONE
#5) Straight - DONE
#4) Three of a Kind - DONE
#3) Two pair - DONE
#2) Pair - DONE
#1) High Card - DONE

#Need to fix:
#High card checker needs to accomodate Aces - DONE

#THINGS TO FIX (Accomodate Ace):

#Two Pair
#Full House - FIXED
#Three of a Kind - FIXED
#4 of a kind - FIXED
#1 Pair

#START OF MODULE
defmodule Poker do

#DEAL CARDS WITH SINGLE LIST TO 2 LISTS
#list1 will be from position 10 8 6 4 2 in the main list
#list2 will be from position  9 7 5 3 1 in the main list

    def deal(mainlist) do
        list1 = []
        list2 = []
        counter = 10
        listOfList = dealcardsHelper(mainlist,counter,list1,list2)
        list1 = elem(listOfList,0) #First List
        list2 = elem(listOfList,1) #Second List

        stringList(compareLists(list1,list2))
    end

    def dealcardsHelper(mainlist,counter,list1,list2) do
        if counter==0 do #when counter hits zero, no more cards to deal
            listOfList = {list1,list2} #return the two lists generated with this recursive algorithm
            listOfList

         #this will simulate an alternating sequence of giving every other card to each player
        else
            if rem(counter,2)==0 do
                list1 = list1++[hd(mainlist)]
                dealcardsHelper(tl(mainlist),counter-1,list1,list2)
            else
                list2 = list2++[hd(mainlist)]
                dealcardsHelper(tl(mainlist),counter-1,list1,list2)
            end
        end
    end

#END OF DEAL CARDS WITH SINGLE LIST TO 2 LISTS

#TIE BREAKER CODE
    def tieBreaker(10, list1, list2) do #Tie Breaker for Royal Flush
    #Check Suite of the Royal Flush
        result = checkSuite(list1,list2)

        if result==1 do
            #IO.puts 'List 1 has a higher suite Royal Flush'
            result
        else
            if result==0 do
                #IO.puts 'List 2 has a higher suite Royal Flush'
                result
            else
                2
            end
        end
        result
    end

    def tieBreaker(9, list1, list2) do #Tie Breaker for Straight Flush
    #Check for Highest card for straights (Ace has value 1)
    #If the high card is the same, the high card function also checks the suite
        result = checkHighCardforStraights(list1,list2)

        if result==1 do
            #IO.puts 'List 1 has a higher Straight Flush'
            result
        else
            if result==0 do
                #IO.puts 'List 2 has a higher Straight Flush'
                result
            else
                2
            end
        end
    end


    def tieBreaker(8, list1, list2) do #Tie Breaker for 4 of a Kind
    # Higher 4 of a Kind Wins, impossible to have more than 1 duplicate so this simple algorithm works.
        duplicatesList1 = findDuplicates(list1)
        duplicatesList2 = findDuplicates(list2)
        if hd(duplicatesList1)>hd(duplicatesList2) do
            if hd(duplicatesList2)==1 do
                #IO.puts 'List 2 has a higher 4 of a Kind'
                0
            else
                #IO.puts 'List 1 has a higher 4 of a Kind'
                1
            end
        else
            if hd(duplicatesList1)<hd(duplicatesList2) do
                if hd(duplicatesList1)==1 do
                    #IO.puts 'List 1 has a higher 4 of a Kind'
                    1
                else
                    #IO.puts 'List 2 has a higher 4 of a Kind'
                    0
                end
            else
                #at this point theyre equal NOT POSSIBLE
                2
            end
        end
    end

    def tieBreaker(7, list1, list2) do #Tie Breaker for FullHouse
    #We simply compare the 3 of a kind in each hand to see which hand has the highest 3 of a kind
        duplicatesList1 = findDuplicates(list1)
        duplicatesList2 = findDuplicates(list2)
        
        list1ThreeOfAKindValue = if (findnum(list1, hd(duplicatesList1)))==3 do hd(duplicatesList1) else hd(tl(duplicatesList1)) end

        list2ThreeOfAKindValue = if (findnum(list2, hd(duplicatesList2)))==3 do hd(duplicatesList2) else hd(tl(duplicatesList2)) end

        if list1ThreeOfAKindValue>list2ThreeOfAKindValue do
            if list2ThreeOfAKindValue==1 do
                #IO.puts 'List 2 has a higher FullHouse'
                0
            else
                #IO.puts 'List 1 has a higher FullHouse'
                1
            end
        else
            if list1ThreeOfAKindValue<list2ThreeOfAKindValue do
                if list1ThreeOfAKindValue==1 do
                    #IO.puts 'List 1 has a higher FullHouse'
                    1
                else
                    #IO.puts 'List 2 has a higher FullHouse'
                    0
                end
            else
                #at this point theyre equal NOT POSSIBLE
                #IO.puts 'Something went wrong'
                2
            end
        end
    end

    def tieBreaker(6, list1, list2) do #Tie Breaker for Flush
    #check highest card, highest card function will move on to check the suite if they are identical
        result = checkHighCard(list1,list2)

        if result==1 do
            #IO.puts 'List 1 has a higher Flush'
            result
        else
            if result==0 do
                #IO.puts 'List 2 has a higher Flush'
                result
            else
                result
            end
        end
    end

    def tieBreaker(5, list1, list2) do #Tie Breaker for Straight
    #check highest card, use the highestcardforstraights function, it will check suite if its the same straight.
    #Check for Highest card for straights (Ace has value 1)
        result = checkHighCardforStraights(list1,list2)
        if result==1 do
            #IO.puts 'List 1 has a higher Straight'
            result
        else
            if result==0 do
                #IO.puts 'List 2 has a higher Straight'
                result
            else
                result
            end
        end
    end

    def tieBreaker(4, list1, list2) do #Tie Breaker for Three Of A Kind
        duplicatesList1 = findDuplicates(list1)
        list1ThreeOfAKindValue = hd(duplicatesList1)

        duplicatesList2 = findDuplicates(list2)
        list2ThreeOfAKindValue = hd(duplicatesList2)

        if list1ThreeOfAKindValue>list2ThreeOfAKindValue do
            if list2ThreeOfAKindValue==1 do
                #IO.puts 'List 2 has a higher Three Of A Kind'
                0
            else
                #IO.puts 'List 1 has a higher Three Of A Kind'
                1
            end
        else
            if list1ThreeOfAKindValue<list2ThreeOfAKindValue do
                if list1ThreeOfAKindValue==1 do
                    #IO.puts 'List 1 has a higher Three Of A Kind'
                    1
                else
                    #IO.puts 'List 2 has a higher Three Of A Kind'
                    0
                end
            else
                #at this point theyre equal NOT POSSIBLE
                #IO.puts 'Something went wrong'
                2
            end
        end
    end

    def tieBreaker(3, list1, list2) do #Tie Breaker for Two Pair

        duplicatesList1 = Enum.sort(findDuplicates(list1), :asc)
        duplicatesList2 = Enum.sort(findDuplicates(list2), :asc)
        
        list1TwoPairValue1 = 0
        list1TwoPairValue2 = 0
        
        list1TwoPairValue1 = hd(duplicatesList1)
        list1TwoPairValue2 = hd(tl(duplicatesList1))

        list2TwoPairValue1 = 0
        list2TwoPairValue2 = 0

        list2TwoPairValue1 = hd(duplicatesList2)
        list2TwoPairValue2 = hd(tl(duplicatesList2))

        #IO.puts list1TwoPairValue1
        #IO.puts list1TwoPairValue2
        #IO.puts list2TwoPairValue1
        #IO.puts list2TwoPairValue2

        result = 2


        if list1TwoPairValue1>list2TwoPairValue1 do #compare first of list 1 with first of list 2
            if list2TwoPairValue1==1 do
                #IO.puts 'List 2 has a higher Two Pair'
                0
            else
                #IO.puts 'List 1 has a higher Two Pair'
                1
            end
        else
            if list1TwoPairValue1<list2TwoPairValue1 do # otherwise compare list 1 with first of list 2 again.
                if list1TwoPairValue1==1 do
                    #IO.puts 'List 1 has a higher Two Pair'
                    1
                else
                    #IO.puts 'List 2 has a higher Two Pair'
                    0
                end
            else
                 #at this point first ones are the same check second of list 1 with second of list 2

                if list1TwoPairValue2>list2TwoPairValue2 do #comparing second of list 1 with second of list 2
                    if list2TwoPairValue2==1 do
                        #IO.puts 'List 2 has a higher Two Pair'
                        0
                    else
                        #IO.puts 'List 1 has a higher Two Pair'
                        1
                    end
                else
                    if list1TwoPairValue2<list2TwoPairValue2 do #again checking second of list 1  with second of list 2
                        if list1TwoPairValue2==1 do
                            #IO.puts 'List 1 has a higher Two Pair'
                            1
                        else
                            #IO.puts 'List 2 has a higher Two Pair'
                            0
                        end
                    else
                        #at this point theyre equal NOT POSSIBLE # At this point they are the same, check high card between the last card
                         #at this point both the pairs are equivalent, check high card between the last cards

                        list1LastCard = hd(Enum.reject(list1, fn n-> n in duplicatesList1 end))
                        list2LastCard = hd(Enum.reject(list2, fn n-> n in duplicatesList2 end))

                        list1LastCard = rem(list1LastCard-1,13)+1
                        list2LastCard = rem(list2LastCard-1,13)+1

                        if list1LastCard>list2LastCard do #comparing second of list 1 with second of list 2
                            if list2LastCard==1 do
                                #IO.puts 'List 2 has a higher Two Pair'
                                0
                            else
                                #IO.puts 'List 1 has a higher Two Pair'
                                1
                            end
                        else
                            if list1LastCard<list2LastCard do #again checking second of list 1  with second of list 2
                                if list1LastCard==1 do
                                    #IO.puts 'List 1 has a higher Two Pair'
                                    1
                                else
                                    #IO.puts 'List 2 has a higher Two Pair'
                                    0
                                end
                            else
                                #at this point, the hands are exactly identical besides suite, check suite of highest card
                                result = checkHighCard(list1,list2)
                                if result==1 do
                                    #IO.puts 'List 1 has the higher Two Pair'
                                    result
                                else
                                    if result==0 do
                                        #IO.puts 'List 2 has the higher Two Pair'
                                        result
                                    else
                                        #IO.puts 'Something went wrong (Two pair check)'
                                        result
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    def tieBreaker(2, list1, list2) do #Tie Breaker for One Pair
        #simply find which cards are duplicates, and compare the value of the pairs in each list
        #if they are the same pair, generally get the highest card, high card implements high suite if
        #the hand is identical

        duplicatesList1 = findDuplicates(list1)
        list1OnePairValue = hd(duplicatesList1)

        duplicatesList2 = findDuplicates(list2)
        list2OnePairValue = hd(duplicatesList2)

        if list1OnePairValue>list2OnePairValue do #comparing second of list 1 with second of list 2
            if list2OnePairValue==1 do
                #IO.puts 'List 2 has a higher Pair'
                0
            else
                #IO.puts 'List 1 has a higher Pair'
                1
            end
        else
            if list1OnePairValue<list2OnePairValue do #again checking second of list 1  with second of list 2
                if list1OnePairValue==1 do
                    #IO.puts 'List 1 has a higher Pair'
                    1
                else
                    #IO.puts 'List 2 has a higher Pair'
                    0
                end
            else
                # list1OnePairValue is equivalent to list2OnePairValue, check the highest card among the two lists
                result = checkHighCard(list1,list2)
                if result==1 do
                    #IO.puts 'List 1 has a Higher Hand'
                    result
                else
                    if result==0 do
                        #IO.puts 'List 2 has a Higher Hand'
                        result
                    else
                        2
                    end
                end
            end
        end
    end

    def tieBreaker(1, list1, list2) do #Tie Breaker for High Card
        #We simply use our high card checker
        checkHighCard(list1,list2)
    end

#END OF TIE BREAKER
    def compareNums(n1,n2) do #Specifically makes 1 Highest Rank
        n1 = rem(n1-1,13)+1
        n2 = rem(n2-1,13)+1
        if n1>n2 do
            if n2==1 do
                0
            else
                1
            end
        else
            if n1<n2 do
                if n1==1 do
                    1
                else
                    0
                end
            else
                2
            end
        end
    end

#REDO THIS COMPARE FUNCTION
    def compareLists(list1,list2) do
        #IO.write 'List 1 is a '
        listValue1 = highestHandCheck(list1)
        printlist(list1)
        #IO.puts " "
        #IO.write 'List 2 is a '
        listValue2 = highestHandCheck(list2)
        printlist(list2)
        #IO.puts " "

        if listValue1>listValue2 do
            #IO.puts 'List 1 Wins!'
            printlist(list1)
            list1
        else
            if listValue1<listValue2 do
                #IO.puts 'List 2 Wins!'
                printlist(list2)
                list2
            else
                if listValue1==listValue2 do
                    result = tieBreaker(listValue1,list1,list2)

                    if result==1 do
                        #IO.puts 'List 1 Wins!'
                        printlist(list1)
                        list1 #RETURN LIST
                    else
                        if result==0 do
                            #IO.puts 'List 2 Wins!'
                            printlist(list2)
                            list2 #RETURN LIST
                        else
                            #IO.puts 'Sorry, it appears as if you tried using the same card twice.'
                            #IO.puts 'Either that, or the list you tried entering is THE EXACT SAME'
                            #IO.puts 'This case is impossible with 1 deck of 52 cards, consider this a tie.'
                            []
                        end
                    end
                end
            end
        end
    end

#NEED TO REDO THIS

#START OF HIGHEST HAND CHECK - takes a list and returns the highest possible hand that it has
    def highestHandCheck(list) do
        if checkRoyalFlush(list)==true do
            #:royalFlush
            #IO.puts 'Royal Flush'
            10
        else
            if checkStraightFlush(list)==true do
                #:straightFlush 
                #IO.puts 'Straight Flush'
                9
            else
                if ofAKindCheck(list)==:fourOfAKind do
                    #:fourOfAKind
                    #IO.puts 'Four of a Kind'
                    8
                else
                    if twoPairCheck(list)==:fullhouse do
                        #:fullhouse
                        #IO.puts 'Full House'
                        7
                    else
                        if flushCheck(list)==true do
                            #:flush
                            #IO.puts 'Flush'
                            6
                        else
                            if straightCheck(list)==true do
                                #:straight
                                #IO.puts 'Straight'
                                5
                            else
                                if ofAKindCheck(list)==:threeOfAKind do
                                    #:threeOfAKind
                                    #IO.puts 'Three of a Kind'
                                    4
                                else
                                    if twoPairCheck(list)==:twopair do #two pairs, not one pair
                                        #:twopair
                                        #IO.puts 'Two Pair'
                                        3
                                    else
                                        if ofAKindCheck(list)==:twoOfAKind do #ONE PAIR/Two of a Kind
                                            #:twoOfAKind
                                            #IO.puts 'One Pair (Two of a Kind)'
                                            2
                                        else
                                            #:highcard
                                            #IO.puts 'High Card'
                                            1
                                        end
                                    end
                                end
                            end

                        end

                    end
                end
            end
        end
    end

    #END OF HIGHEST HAND CHECK

   #1 means list1 wins
   #0 means list2 wins
   #2 means tie

   #true means yes
   #false means no

#START OF MAIN FUNCTION
   def main do
      
      list = [1,2,5,4,3,6,8]

      list = sortlist(list)
      printlist(list) 
      straightCheck(list)
      #checkHighCard([1,2],[14,16])

      #checkSuite([2,3],[1,2])
   end
#END OF MAIN FUNCTION


#COUNT SIMILAR CARDS

   def maxnum(x,y) do
      if x>y do
         x
      else
         y
      end
   end

#START OF ROYAL FLUSH CHECKER

def checkRoyalFlush(list) do
    simplifiedList = []
    simplifiedList = simplifyList(list)
    simplifiedList = Enum.sort(simplifiedList, :asc)

    if (simplifiedList==[1,10,11,12,13]) do
        if (flushCheck(list)==true) do
            true
        else
            false
        end
    else
        false
    end
end
# END OF ROYAL FLUSH CHECKER



# START OF TWO, THREE, AND FOUR OF A KIND CHECKER - Pre-req: duplicatesList must have 1 element
def ofAKindCheck(list) do
    duplicatesList = findDuplicates(list)
    ofAKindCheckHelper1(list,duplicatesList)
end

def ofAKindCheckHelper1(list,duplicatesList) do
    list = simplifyList(list)
    if (Enum.count(duplicatesList)==1) do
        repeatedElement = returnFirst(duplicatesList)
        ofAKindCheckHelper2(list,repeatedElement)
    else
        false
    end
end

def ofAKindCheckHelper2(list, repeatedElement) do
    amount=findnum(list,repeatedElement) #number of times the element is repeated
    if amount>2 do
        if amount>3 do
            :fourOfAKind
        else
            :threeOfAKind
        end
    else
        :twoOfAKind
    end
end
#END OF TWO, THREE, AND FOUR OF A KIND CHECKER

# TWO PAIR AND FULLHOUSE CHECK - Pre-req: Make sure the duplicateList that it takes has atleast Two Elements
def twoPairCheck(list) do
    duplicatesList = findDuplicates(list)
    twoPairCheckHelper1(list,duplicatesList)
end

def twoPairCheckHelper1(list,duplicatesList) do
    if (Enum.count(duplicatesList)==2) do
        twoPairCheckHelper2(list,duplicatesList)
    else
        false
    end
end

def twoPairCheckHelper2(list,[h|t]) do # Possibilities: 2 and 2 (Two Pair), or 3 and 2 (FullHouse)
        if (maxnum(findnum(list,h),findnum(list,returnFirst(t)))==3) do #checks if the highest number is 3 or 2, this decides whether its fullhouse or not
            :fullhouse
        else
            :twopair
        end
end

def returnFirst([h|t]) do
    h
end
# END OF TWO PAIR AND FULL HOUSE CHECK

# START OF FINDING DUPLICATES - will take a list and return a list of duplicate items within the list.
def findDuplicates(list) do
    duplicatesList = []
    duplicatesList = findDuplicatesHelper(simplifyList(list),duplicatesList)
    duplicatesList

end
def findDuplicatesHelper([h|t],duplicatesList) do
    if t==[] do #basecase
        duplicatesList
    else
        if (findnum(t,h)!=0) do #check if item appears again in tail
            if findnum(duplicatesList,h)==0 do #if it does, check if its already recorded in the list of duplicates
                duplicatesList = duplicatesList++[h]
                findDuplicatesHelper(t,duplicatesList) #if element is not already part of list of duplicates, add it, and move onto next recursive call
            else #if its already in the duplicates list, dont do anything, move onto next recursive call
                findDuplicatesHelper(t,duplicatesList)
            end
        else #if it doesnt appear again in tail, move to next recursive call
            findDuplicatesHelper(t,duplicatesList)
        end 
    end
end

#END OF FINDING DUPLICATES

def findnum(list,n) do #Returns number of times number appears in list
    list = simplifyList(list)
    if n==0 do
        n=13
    else
        n = rem(n,13)
    end
#returnFirst([]++[x]) == returnFirst([]++[n]) - OLD SOLUTION for line at the bottom of this
    list = (Enum.filter(list, fn x -> x==n end))
    amount = Enum.count(list)
    amount
end

#END OF COUNT SIMILAR CARDS


def checkStraightFlush(list) do
    if (flushCheck(list)==true) do
        if (straightCheck(list)==true) do
            true
        else
            false
        end
    else
        false
    end
end
    

#START OF FLUSH CHECKER - RETURNS TRUE OR FALSE

   def flushCheck([h|t]) do
      suite = suiteChecker(h)
      flushCheckHelper(t,suite)
   end

   def suiteChecker(n) do
      if n>13 do
         if n>26 do
            if n>39 do
               3
            else
               2
            end
         else
            1
         end
      else
         0
      end
   end

   def flushCheckHelper([h|t],suite) do
      if suiteChecker(h)==suite do
         if t==[] do
            true
         else 
            flushCheckHelper(t,suite)
         end
      else
         false
      end
   end

#END OF FLUSH CHECKER

# LIST SIMPLIFIER - converts cards with suits to numbers 1-13
def simplifyList(list) do
    list = Enum.map(list, fn x -> if (rem(x,13)==0) do 13 else rem(x,13) end end)
    list
    end
# END OF LIST SIMPLIFIER

#START OF STRAIGHTCHECKER
   def straightCheck(list) do
    list = simplifyList(list)
    straightCheckHelper1(Enum.sort(list, :asc))
   end

   def straightCheckHelper1([h|t]) do
    #exception for Ace
        if h==13 do
            straightCheckHelper2(t,1)
        else
            if (h+9)==returnFirst(t) do
                straightCheckHelper2(t,h+9)
            else     
                straightCheckHelper2(t,h+1)
            end
        end
    end
   
   def straightCheckHelper2([h|t],n) do
      if n==h do
         if t==[] do
            true
         else
            if n==13 do
                straightCheckHelper2(t,1)
            else
                if (n+9)==returnFirst(t) do
                    #THIS WILL RESTRICT THE "JUMP" FROM K -> A
                    if n==1 do
                        straightCheckHelper2(t,n+9)
                    else
                        false
                    end
                else     
                    straightCheckHelper2(t,n+1)
                end
            end
         end
      else
         false
      end
   end

#END OF STRAIGHTCHECKER


#START OF CHECK HIGH CARD - will check for highest card, else check for highest suite.
#If checking high card shows same, then it will take the high cards from each list and check their suites. 

#SOLUTION TO MAKE ACE HIGH CARD - NOT DONE

def checkHighCard(list1,list2) do 

list1Aces = Enum.filter(list1, fn n-> rem(n,13)==1 end) #list of aces for list1
list1Rest = Enum.reject(list1, fn n-> rem(n,13)==1 end) #list of rest for list1

list2Aces = Enum.filter(list2, fn n-> rem(n,13)==1 end) #list of aces for list2
list2Rest = Enum.reject(list2, fn n-> rem(n,13)==1 end) #list of rest for list2

#mandatorysorting in descending order for all lists
list1 = Enum.sort(list1, :desc)
list2 = Enum.sort(list2, :desc)
list1Aces = Enum.sort(list1Aces, :desc)
list1Rest = Enum.sort(list1Rest, :desc)
list2Aces = Enum.sort(list2Aces, :desc)
list2Rest = Enum.sort(list2Rest, :desc)

list1AceCount = Enum.count(list1Aces)
list2AceCount = Enum.count(list2Aces)

#IO.puts list1AceCount
#IO.puts list2AceCount

#CHECKING ACES
if list1AceCount>list2AceCount do #if list1 has more aces
    1
else
    if list2AceCount>list1AceCount do #if list 2 has more aces
        0
    else
        result = checkHighCardHelper1(list1Rest,list2Rest) #check rest of the list since they have equal number of aces

        if (result==2) do
            #rest of the list is same, get result by checking suite of the highest ace.
            if list1AceCount==0 do
                result = checkSuite(list1Rest,list2Rest)
                result 
            else 
                result = checkSuite(list1Aces,list2Aces)
                result
            end
        else
            result
        end
    end
end

#Lists have equal number of aces. Now check rest of list


end


def checkHighCardHelper1([h|t],[h2|t2]) do
  if (rem(h,13)==rem(h2,13)) do
     if (t==[]) do
        2
     else 
        checkHighCardHelper1(t,t2)
     end
  else
    if (((h==13) or (h2==13))!=true) do
        if (rem(h,13)>rem(h2,13)) do #list 1 wins: return 1, else return 0 to indicate list 2 won
            1
        else
            0
        end
    else
        if h==13 do
            1
        else
            0
        end
    end
  end
end

#END OF SOLUTION TO MAKE ACE HIGH CARD


#START OF SOLUTION FOR REGULAR HIGH CARD CHECKING (used for straights)

   def checkHighCardforStraights(list1,list2) do #WORKS
    list1 = Enum.sort(list1, :desc)
    list2 = Enum.sort(list2, :desc)
    result = checkHighCardHelper1forStraights(list1,list2)
    if  (result == 2) do
        checkSuite(list1,list2)
    else
        result
    end
   end

   def checkHighCardHelper1forStraights([h|t],[h2|t2]) do
    if ((rem(h-1,13)+1)==(rem(h2-1,13)+1)) do
        if (t==[]) do
            2
        else 
            checkHighCardHelper1forStraights(t,t2)
        end
    else
        if ((rem(h-1,13)+1)>(rem(h2-1,13)+1)) do
            1
        else
            if ((rem(h-1,13)+1)<(rem(h2-1,13)+1)) do
                0
            else
                2
            end
        end
    end
   end

   def checkSuite([h|t],[h2|t2]) do #will check which list head has the highest suite.
      if (h>h2) do
         1
      else
        if h2>h do
            0
        else
            2
        end
      end
   end

#END OF CHECK HIGH CARD (for straights)

#START OF SORT LIST
   def sortlist(list) do
      Enum.reverse(Enum.sort(list))
   end
#END OF SORT LIST

#Clubs: 1-13
#Diamonds: 14-26
#Hearts: 27-39
#Spades: 40-52

    def printlist(list) do # Sort it according to its Rank first, then sort similar cards by their suite
        list = Enum.sort(list, :asc)
        list = Enum.sort(list, fn a,b -> if rem(a-1,13)==rem(b-1,13) do a<b else rem(a-1,13)<rem(b-1,13) end end)

        letterList = numToLetter(list)

        #IO.puts(["The List is: ", Enum.join(letterList, " ")]) # Print the list
    end

    def stringList(list) do # Sort it according to its Rank first, then sort similar cards by their suite
    list = Enum.sort(list, :asc)
    list = Enum.sort(list, fn a,b -> if rem(a-1,13)==rem(b-1,13) do a<b else rem(a-1,13)<rem(b-1,13) end end)

    letterList = numToLetter(list)
    letterList
    end

        #convert higher values to their suites. Ex: 1 -> AC, 15 -> 2D
    def numToLetter(list) do 
        letterList = Enum.map(list, fn n-> getNumber(n)<>getSuite(n) end) 
    end

    def getNumber(n) do #returns true value, ex 14 -> "1", 28-> "2"
        to_string(rem(n-1,13)+1)
    end

    def getSuite(n) do
        if n<=13 do
            "C"
        else
            if n<=26 do
                "D"
            else
                if n<=39 do
                    "H"
                else
                    if n<=52 do
                        "S"
                    else
                        "Error: Card Exceeds 52"
                    end
                end
            end
        end
    end
#END OF PRINT LIST
end
#END OF MODULE