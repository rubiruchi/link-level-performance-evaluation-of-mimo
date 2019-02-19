clear; close all;
load('ber_set.mat')
% numBerMl(end) = 4e-4;
%% BER comparison
semilogy(snrDb, numBerMl, '-o');
hold on;
semilogy(snrDb, numBerZf, '-*');
hold on;
semilogy(snrDb, numBerUnorderedZfSic, '--x');
grid on;
legend('ML', 'ZF', 'Unordered ZF-SIC');
title('BER vs SNR of 2-by-2 MIMO system with different receivers');
xlabel('SNR (dB)');
ylabel('BER');
