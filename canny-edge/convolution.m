%% Inspired by MATLAB function conv2
function result = convolution(A, B) % assume A is bigger
  [A_rows,A_cols] = size(A);
  [B_rows,B_cols] = size(B);
  c = zeros(B_rows+A_rows-1, B_cols+A_cols-1);
  rows = 0:A_rows-1;
  cols = 0:A_cols-1;
  for j=1:B_cols
	for i=1:B_rows
		Bij = B(i,j);
		if Bij~=0
			c(i+rows,j+cols) = c(i+rows,j+cols) + Bij*A;
		end
	end
  end
  rows = floor(B_rows/2) + (1:A_rows);
  cols = floor(B_cols/2) + (1:A_cols);
  result = c(rows,cols); % only get the part that's the size of B