function glccm  = computeGrayLevelCoCurrenceMatrix(I, levels)
directions = [1 0 0; 1 1 0; -1 1 0; 0 1 0; 0 1 1; 0 -1 1; 0 0 1; 1 0 1; -1 0 1; -1 1 1; 1 -1 1; 1 1 1; -1 -1 1];
nDirections = 13;
nLevels = length(levels);
glccm = zeros(nLevels, nLevels, nDirections);
nRow = size(I,1);
nCol = size(I,2);
nSli = size(I,3);
for k = 1:nSli
    for j = 1:nCol
        for i = 1:nRow
            currentPixelValue = I(i,j,k);
            rowIndex = find(levels == currentPixelValue);
            for l = 1:nDirections
                offset = [i+directions(l,1) j+directions(l,2) k+directions(l,3)];
                if (offset(1) < 1) || (offset(1) > nRow) || (offset(2) < 1) || (offset(2) > nCol) || (offset(3) < 1) || (offset(3) > nSli)
                    continue
                else
                    offsetPixelValue = I(offset(1), offset(2), offset(3));
                    colIndex = find(levels == offsetPixelValue);
                    glccm(rowIndex, colIndex, l) = glccm(rowIndex, colIndex, l)+1;
                end
            end
            
        end
    end
end