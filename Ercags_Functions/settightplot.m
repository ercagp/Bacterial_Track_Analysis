function settightplot(ax) 
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2) + 0.010;
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4) - 0.005;
ax.Position = [left bottom ax_width ax_height];
end 
