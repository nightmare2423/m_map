clear,clf,close all;
clc;
load('data.mat');
S=-90;%维度的界线
N=90;
W=-180;%经度的界线
E=180;
S_N_L=180;%像素点的个数
W_E_L=360;
mylat=linspace(S,N,S_N_L);
mylon=linspace(W,E,W_E_L);
%初始化存放颜色的矩阵
Colormap=zeros(S_N_L,W_E_L,3);
T0=data;

T=T0;%初始化
for i=1:100
    Colormap=getcolor(T);
    m_proj('miller','lat',[S N],'lon',[W E]);
    m_image(mylon,mylat,uint8(Colormap));
    m_grid off;
    m_coast('patch',[0.7415 0.7415 0.7415],'edgecolor','g');
    %m_grid('xtick',mylon,'ytick',mylat,'xticklabels',[],'yticklabels',[]);
    title(num2str(i));
    shg;
    T=getT(T);
end

function T=getT(T)
%设置卷积核，方便直接求出下一年的数据
core=[0 1 0;1 1 1;0 1 0]/5;
T_temp=conv2(T,core,'same');
%还是直接循环简单，用find反而麻烦了
for i=1:size(T_temp,1)
    for j=1:size(T_temp,2)
        if T_temp(i,j)>T(i,j)
            T(i,j)=T_temp(i,j)+1;
        elseif T_temp(i,j)==T(i,j)
            T(i,j)=mean(T_temp(:))+2;
        end
    end
end
end

function Color=getcolor(T)
%根据温度值，计算每一个点对应的rgb值
%先直接简单的分级并赋值
T_level=[0 5 10 20 30 40 50];
Color=zeros(size(T,1),size(T,2),3);
for i=1:size(T,1)
    for j=1:size(T,2)
        temp=T(i,j);
        for k=1:length(T_level)
            if temp<=T_level(k)
                Color(i,j,:)=getRGB(k);
                break;
            end
        end
    end
end
end

function RGB=getRGB(num)
c=[0 255 255;
    240 230 140;
    210 105 30;
    188 143 143;
    244 162 96;
    255 127 80;
    255 0 0];
RGB=c(num,:);
end
