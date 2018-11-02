function slope = getSlopeFromApproachCurve(h0, P, Q, R)
	if h0 < P+Q 
        slope = 0;
    else
        slope = tan(acos(((h0-P)/Q)^(1/R)));
    end
end
