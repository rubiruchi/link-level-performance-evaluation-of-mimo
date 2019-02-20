clear; close all;
load('ber_set.mat')
snr = 10 .^ (snrDb / 10);
divMl = diversity_gain(snr, numBerMl');
divZf = diversity_gain(snr, numBerZf');
divUnorderedZfSic = diversity_gain(snr, numBerUnorderedZfSic');
%% BER comparison
figure(1);
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
%% Diversity gains
figure(2);
plot(snrDb, divMl, '-o');
hold on;
plot(snrDb, divZf, '-*');
hold on;
plot(snrDb, divUnorderedZfSic, '--x');
grid on;
legend('ML', 'ZF', 'Unordered ZF-SIC');
title('Diversity gain of 2-by-2 MIMO system with different receivers');
xlabel('SNR (dB)');
ylabel('Diversity gain');
