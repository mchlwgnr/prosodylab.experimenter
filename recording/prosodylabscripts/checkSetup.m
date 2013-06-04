% checkSetup
% check participant number and determine playlist
% % chael@mcgill.ca 11/17/09


function [pList, ok]=checkSetup(participant,design,resultfile,nExperiments)

ok = 1;

pList(nExperiments)=0;


for j=1:nExperiments
    
nPart=[];    
    
[results]=tdfimport(resultfile{j});

[~, nTrials]=size(results);

if nTrials~=0
    
    ok2=~(any(ismember([results(:).participant],participant)));
    
    if ~ok2
        disp(sprintf('%s\n',['There is already a participant with that number in experiment ' results(1).experiment '!']));
        ok=0;
    else
        
        if design(1)>3
            
            nLists = max([results(:).condition]);
            nPart(nLists)=0;
            
            [values count]=howmany([results(:).playlist]);
            [numPlists,~]=size(values);
            
            if numPlists>nLists
                disp(sprintf('\n%s\n','Problem with PlayList Column in Responses File!'));
                pList(j)=1;
            else
                assignments=[[results(:).playlist];[results(:).participant]];
                for i=1:numPlists
                    numPart=assignments(1,:)==values(i);
                    [~,partsize]=size(unique(assignments(2,numPart)));
                    nPart(i)=partsize;
                end
                
                if  numPlists<nLists
                    pList(j)=numPlists+1;
                else
                    [~, index]=min(nPart);
                    pList(j)=values(index);
                end
            end
            
            disp(sprintf('\n%s',['Experiment: ' results(1).experiment ]));
            
            disp(sprintf('\n%s',['Names of Playlists that have been played: ' num2str(values')]));
            
            disp(sprintf('%s',['Participants per for each list so far    : ' num2str(nPart)]));
            
            disp(sprintf('\n%s\n',['Assigned Playlist : ' num2str(pList(j))]));
            
            
            while KbCheck(-1); end;
            disp('ok?');
            while ~KbCheck(-1); end;
            
            [~, ~, keyCode]=KbCheck(-1);
            
            if strcmp('n',KbName(keyCode))
                plistchoice=input('Please enter the desired playlist number: ', 's');
                pList(j)=str2num(plistchoice);
            end   
        else
            [~, nParticipants]=size([unique([results(:).participant])]);
            disp(sprintf('\n%s',['Experiment: ' results(1).experiment ]));
            disp(sprintf('\n%s',['Number of Participants: ' num2str(nParticipants) ]));
            pList(j)=1;
            
            while KbCheck(-1); end;
            disp('ok?');
            while ~KbCheck(-1); end;
            
            [~, ~, keyCode]=KbCheck(-1);
        end
    end
else
    pList(j)=1;
end
end
end