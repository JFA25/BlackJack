function blackjack(deck)
% BLACKJACK plays the game blackjack
%{
 Jose Arroyo
 ITP 168, Spring 2018
 HW7
 jfarroyo@usc.edu
 
Revision History

Date        Changes         Programer
03/26/18    Original        Jose Arroyo
%}

if deck <= 0
    error('Must be a Positive Integer');
end
if ~(isnumeric(deck)) || ~(isscalar(deck)) || ~(mod(deck,1) == 0)
    error('Must be Integer, Numeric, and a Scalar');
end
if nargin > 1
    error('To Many Input Values');
end

deck = initdeck(deck); % create deck
sDeck = shuffle(deck); % shuffle deck
[plCard(1), sDeck] = dealcard(sDeck); % player's cards
[plCard(2), sDeck] = dealcard(sDeck);
[dlCard(1) , sDeck] = dealcard(sDeck); % dealer's cards
[dlCard(2) , sDeck] = dealcard(sDeck);
pLen = 2; % player/dealer hand length
dLen = 2;

% calculate score
%     calcscore(deck);
%     printcard(deck);

% player hand
fprintf('Player Has: \n');
printcard(plCard(1));
printcard(plCard(2));

% calculate player score
plScore = calcscore(plCard);
% calculate dealer hand
dlScore = calcscore(dlCard);

fprintf('Player Score: %0.0f\n' , plScore);

fprintf('Dealer Showing: \n'); %dealer hand
printcard(dlCard(1));
%printcard(dlCard(2));


if plScore == 21 && dlScore ~= 21 % player win
    fprintf('Blackjack!\nPlayer Wins!');
end

if dlScore == 21 && plScore ~= 21 % dealer win
    fprintf('Blackjack!\nDealer Wins!\n');
end

if plScore == dlScore
    fprintf('Push!\n');
    plScore = 22;
end

if plScore ~= 21 && dlScore ~= 21 % neither player score = 21
    while plScore <= 21
        fprintf('Choose from Following: \n');
        fprintf('     1. Hit\n     2. Stand\n');
        userIn = input('Choose: ');
        
        switch userIn
            case 1 % hit
                [plCard(pLen + 1), sDeck] = dealcard(sDeck);
                pLen = pLen + 1;
                fprintf('Player Drew: \n');
                printcard(plCard(pLen));
                % calc new score after hit
                plScore = calcscore(plCard);
                fprintf('Player Score: %0.0f\n' , plScore);
                
            case 2 % stand
                fprintf('-------------\n');
                break;
            otherwise
                error('Invalod Choice!'); % \n
        end
    end
    % player score > dealer
    if  plScore > 21
        fprintf('Dealer Wins!\n');
    end
    
    
    % player score < 21
    if plScore <= 21
        fprintf('Dealer Has: \n');
        printcard(dlCard(1));
        printcard(dlCard(2));
        fprintf('Dealer Score: %d\n', dlScore);
        % while dealer score < 18: dealer hits
        while dlScore < 18
            % update dealer hand
            [dlCard(dLen + 1) , sDeck] = dealcard(sDeck);
            dLen = dLen + 1;
            % print dealer card
            fprintf('Dealer Was Delt: \n');
            printcard(dlCard(dLen));
            %calc dealer score
            dlScore = calcscore(dlCard);
            fprintf('Dealer Score: %d\n', dlScore);
            % dealer hand
            fprintf('Dealer Has: \n');
            printcard(dlCard(1));
            printcard(dlCard(2));
            printcard(dlCard(3));
            
            if dLen > 3
                dLen = dLen + 1;
                printcard(dlCard(4));
                dLen = dLen + 1;
                if dLen
                    dLen = dLen + 1;
                    printcard(dlCard(5));
                end
                
            end
        end
        % dealer score > 21: player wins
        if dlScore > 21
            fprintf('Player Wins!\n');
        else
            if plScore > dlScore
                fprintf('Player Wins!\n');
            elseif dlScore > plScore
                fprintf('Dealer Wins!\n');
            elseif plScore == dlScore
                fprintf('Push!\n'); % note: (' it''s ')
            end
        end
    end
end

end

function out = initdeck(deck)

% if deck < 0
%     error('Must be a Positive Integer');
% end
% if ~isnumeric(deck) || ~isscalar(deck) || ~mod(deck,1) == 0
%     error('Must be Integer, Numeric, and a Scalar');
% end

% card structure

card = struct('suit',[],'value',[],'number',[]);
card = repmat(card,1,52);

cSuit = {'Hearts','Clubs','Diamonds','Spades'};
cVal = {'2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace'};
cNum = {2 3 4 5 6 7 8 9 10 10 10 10 11};


% replicate to form single deck
x = 1;

while x <= 52
    if x <= 13
        for i = 1:13
            card(x).suit = cSuit{1};
            card(x).value = cVal{i};
            card(x).number = cNum{i};
            x = x + 1;
        end
    elseif x <= 26 && x > 13
        for i = 1:13
            card(x).suit = cSuit{2};
            card(x).value = cVal{i};
            card(x).number = cNum{i};
            x = x + 1;
        end
    elseif x <= 39 && x > 26
        for i = 1:13
            card(x).suit = cSuit{3};
            card(x).value = cVal{i};
            card(x).number = cNum{i};
            x = x + 1;
        end
    else
        for i = 1:13
            card(x).suit = cSuit{4};
            card(x).value = cVal{i};
            card(x).number = cNum{i};
            x = x + 1;
        end
        
    end
end

% replicate struct array for multiple decks
% return card struct as output
out = repmat(card,1,deck);

end

function out = shuffle(deck)
% check structure and elements
if ~(isstruct(deck) || deck < 52)
    % error('Must be a Structure with atleast 52 cards');
end

% two random values, one max of deck
var = length(deck);

% swap cards in deck(s)
for i = 1:3000
    var1 = randi(var);
    var2 = randi(var);
    t = deck(var1);
    deck(var1) = deck(var2);
    deck(var2) = t;
end

% return shuffled deck array
out = deck(var:-1:1);
end

function [out1, out2] = dealcard(deck)

if ~isstruct(deck)
end

fCard = deck(1);
newDeck = deck(2:end);

out1 = fCard;
out2 = newDeck;
end

function out = calcscore(hand)

hLen = length(hand);
ace = 0;
score = 0;

for i = 1:hLen
    score = score + hand(i).number; %  was .value %%% switch num to value %%%
    if hand(i).value == 11      %%%%% SWITCH value to number %%%%%
        ace = ace + 1;          
    end
end

while ace > 0 && score > 21
    ace = ace - 1;
    score = score - 10;
end
out = score;
end

function printcard(fCard)
fprintf('%s of %s\n' , fCard.value, fCard.suit);
end

