function FNplot(Element)
element_num = max(size(Element));
for i = 1:element_num
    x = [Element(i).joint1.x, Element(i).joint2.x];
    y = [Element(i).joint1.y, Element(i).joint2.y];
    plotforce(1) = -Element(i).force(1);
    plotforce(2) = -Element(i).force(2);
    plotforce(3) = Element(i).force(3);
    plotforce(4) = Element(i).force(4);
    plotforce(5) = Element(i).force(5);
    plotforce(6) = -Element(i).force(6);
    if sin(Element(i).alpha) ~= 0 % for verticle condition
        FN_x = [x(1) + plotforce(1)/abs(Element(1).force(1)), x(2) + plotforce(4)/abs(Element(1).force(4))];
        FN_y = y;
    else
        FN_x = x;
        FN_y = [y(1) + plotforce(1)/abs(Element(1).force(1)), y(2) + plotforce(4)/abs(Element(1).force(4))];
    end
    plot(x,y,'lineWidth',2, 'Color', 'black')
    hold on;
    plot(FN_x,FN_y,'lineWidth',2, 'Color', 'red')
    plot([x(1), FN_x(1)],[y(1),FN_y(1)],'lineWidth',2, 'Color', 'red')
    plot([x(2), FN_x(2)],[y(2),FN_y(2)],'lineWidth',2, 'Color', 'red')
    text(FN_x(1), FN_y(1),num2str(plotforce(1),'%.3f'),'FontSize',14)
end
title("轴力图","FontSize",14)
xlabel("x/m","FontSize",14)
ylabel("y/m","FontSize",14)

end