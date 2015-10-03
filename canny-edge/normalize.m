function I_normalized = normalize(I)
%% Normalizes the image assuming it is of type double

max_in_I = max(max(I));
I_normalized = I./max_in_I;
