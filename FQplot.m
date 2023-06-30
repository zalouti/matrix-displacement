function FQplot(Element, Force)
force_num = max(size(Force));
element_num = max(size(Element));
flag = 0;
for i = 1: force_num
    if Force(i).kind == 2 && Force(i).category == 2
        flag = Force(i).exert_index;
        distance = Force(i).distance;
    end
end

for i = 1:element_num
    plotforce(1) = -Element(i).force(1);
    plotforce(2) = -Element(i).force(2);
    plotforce(3) = Element(i).force(3);
    plotforce(4) = Element(i).force(4);
    plotforce(5) = Element(i).force(5);
    plotforce(6) = -Element(i).force(6);
    if i ~= flag
        x = [Element(i).joint1.x, Element(i).joint2.x];
        y = [Element(i).joint1.y, Element(i).joint2.y];
        if sin(Element(i).alpha) ~= 0 % for verticle condition
            FQ_x = [x(1) + plotforce(2)/abs(Element(1).force(2)), x(2) + plotforce(5)/abs(Element(1).force(2))];
            FQ_y = y;
        else
            FQ_x = x;
            FQ_y = [y(1) + plotforce(2)/abs(Element(1).force(2)), y(2) + plotforce(5)/abs(Element(1).force(2))];
        end
        plot(x,y,'lineWidth',2, 'Color', 'black')
        hold on;
        plot(FQ_x,FQ_y,'lineWidth',2, 'Color', 'blue')
        plot([x(1), FQ_x(1)],[y(1),FQ_y(1)],'lineWidth',2, 'Color', 'blue')
        plot([x(2), FQ_x(2)],[y(2),FQ_y(2)],'lineWidth',2, 'Color', 'blue')
        text(FQ_x(1), FQ_y(1),num2str(plotforce(2),'%.3f'),'FontSize',14)
        if FQ_y(1) ~= FQ_y(end)
            text(FQ_x(end), FQ_y(end),num2str(plotforce(5),'%.3f'),'FontSize',14)
        end
    else
        if sin(Element(i).alpha) ~= 0 % for verticle condition
            x = [Element(i).joint1.x, Element(i).joint1.x,  Element(i).joint1.x, Element(i).joint2.x];
            y = [Element(i).joint1.y, Element(i).joint1.y + distance, Element(i).joint1.y + distance, Element(i).joint2.y];
            FQ_x = [x(1) + plotforce(2)/abs(Element(1).force(2)), x(1) + plotforce(2)/abs(Element(1).force(2)),...
                x(2) + plotforce(5)/abs(Element(1).force(2)), x(2) + plotforce(5)/abs(Element(1).force(2))];
            FQ_y = y;
        else
            x = [Element(i).joint1.x, Element(i).joint1.x + distance,  Element(i).joint1.x + distance, Element(i).joint2.x];
            y = [Element(i).joint1.y, Element(i).joint1.y, Element(i).joint1.y, Element(i).joint2.y];
            FQ_x = x;
            FQ_y = [y(1) + plotforce(2)/abs(Element(1).force(2)), y(1) + plotforce(2)/abs(Element(1).force(2)), ...
                y(2) + plotforce(5)/abs(Element(1).force(2)), y(2) + plotforce(5)/abs(Element(1).force(2))];
        end
        plot(x,y,'lineWidth',2, 'Color', 'black')
        hold on;
        plot(FQ_x,FQ_y,'lineWidth',2, 'Color', 'blue')
        plot([x(1), FQ_x(1)],[y(1),FQ_y(1)],'lineWidth',2, 'Color', 'blue')
        plot([x(end), FQ_x(end)],[y(end),FQ_y(end)],'lineWidth',2, 'Color', 'blue')
        text(FQ_x(1), FQ_y(1),num2str(plotforce(2),'%.3f'),'FontSize',14)
        text(FQ_x(end), FQ_y(end),num2str(plotforce(5),'%.3f'),'FontSize',14)
    end
end
title("剪力图","FontSize",14)
xlabel("x/m","FontSize",14)
ylabel("y/m","FontSize",14)
end