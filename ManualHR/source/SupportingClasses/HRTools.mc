//! Class providing various assessments of HR
class HRTools {

	function initialize() {
    }
	
	//! function getAssessmentForRestingHR(restingHR, age, gender)
	//! assessment data based on tables from 
	//! http://www.topendsports.com/testing/heart-rate-resting-chart.htm
	function getAssessmentForRestingHR(restingHR, age, gender) {
		if (gender == UserProfile.GENDER_FEMALE) {
			if      (age >= 65) {return self.getAssessmentForRestingHRFemaleAbove65(restingHR);}
			else if (age >= 56) {return self.getAssessmentForRestingHRFemale56to65(restingHR);}
			else if (age >= 46) {return self.getAssessmentForRestingHRFemale46to55(restingHR);}
			else if (age >= 36) {return self.getAssessmentForRestingHRFemale36to45(restingHR);}
			else if (age >= 26) {return self.getAssessmentForRestingHRFemale26to35(restingHR);}
			else if (age >= 18) {return self.getAssessmentForRestingHRFemale18to25(restingHR);}
			else                {return "No data available for young women";}
		}
		else {
			if      (age >= 65) {return self.getAssessmentForRestingHRMaleAbove65(restingHR);}
			else if (age >= 56) {return self.getAssessmentForRestingHRMale56to65(restingHR);}
			else if (age >= 46) {return self.getAssessmentForRestingHRMale46to55(restingHR);}
			else if (age >= 36) {return self.getAssessmentForRestingHRMale36to45(restingHR);}
			else if (age >= 26) {return self.getAssessmentForRestingHRMale26to35(restingHR);}
			else if (age >= 18) {return self.getAssessmentForRestingHRMale18to25(restingHR);}
			else                {return "No data available for young men";}
		}
	}
	
	
	
	function getAssessmentForRestingHRFemale18to25(restingHR) {
		if      (restingHR >= 85) {return "Poor";}
		else if (restingHR >= 79) {return "Below Average";}
		else if (restingHR >= 74) {return "Average";}
		else if (restingHR >= 70) {return "Above Average";}
		else if (restingHR >= 66) {return "Good";}
		else if (restingHR >= 61) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRFemale26to35(restingHR) {
		if      (restingHR >= 83) {return "Poor";}
		else if (restingHR >= 77) {return "Below Average";}
		else if (restingHR >= 73) {return "Average";}
		else if (restingHR >= 69) {return "Above Average";}
		else if (restingHR >= 65) {return "Good";}
		else if (restingHR >= 60) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRFemale36to45(restingHR) {
		if      (restingHR >= 84) {return "Poor";}
		else if (restingHR >= 79) {return "Below Average";}
		else if (restingHR >= 74) {return "Average";}
		else if (restingHR >= 70) {return "Above Average";}
		else if (restingHR >= 65) {return "Good";}
		else if (restingHR >= 60) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRFemale46to55(restingHR) {
		if      (restingHR >= 84) {return "Poor";}
		else if (restingHR >= 78) {return "Below Average";}
		else if (restingHR >= 74) {return "Average";}
		else if (restingHR >= 70) {return "Above Average";}
		else if (restingHR >= 66) {return "Good";}
		else if (restingHR >= 61) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRFemale56to65(restingHR) {
		if      (restingHR >= 84) {return "Poor";}
		else if (restingHR >= 78) {return "Below Average";}
		else if (restingHR >= 74) {return "Average";}
		else if (restingHR >= 69) {return "Above Average";}
		else if (restingHR >= 65) {return "Good";}
		else if (restingHR >= 60) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRFemaleAbove65(restingHR) {
		if      (restingHR >= 84) {return "Poor";}
		else if (restingHR >= 77) {return "Below Average";}
		else if (restingHR >= 73) {return "Average";}
		else if (restingHR >= 69) {return "Above Average";}
		else if (restingHR >= 65) {return "Good";}
		else if (restingHR >= 60) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRMale18to25(restingHR) {
		if      (restingHR >= 82) {return "Poor";}
		else if (restingHR >= 74) {return "Below Average";}
		else if (restingHR >= 70) {return "Average";}
		else if (restingHR >= 66) {return "Above Average";}
		else if (restingHR >= 62) {return "Good";}
		else if (restingHR >= 56) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRMale26to35(restingHR) {
		if      (restingHR >= 82) {return "Poor";}
		else if (restingHR >= 75) {return "Below Average";}
		else if (restingHR >= 71) {return "Average";}
		else if (restingHR >= 66) {return "Above Average";}
		else if (restingHR >= 62) {return "Good";}
		else if (restingHR >= 55) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRMale36to45(restingHR) {
		if      (restingHR >= 83) {return "Poor";}
		else if (restingHR >= 76) {return "Below Average";}
		else if (restingHR >= 71) {return "Average";}
		else if (restingHR >= 67) {return "Above Average";}
		else if (restingHR >= 63) {return "Good";}
		else if (restingHR >= 57) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRMale46to55(restingHR) {
		if      (restingHR >= 82) {return "Poor";}
		else if (restingHR >= 77) {return "Below Average";}
		else if (restingHR >= 72) {return "Average";}
		else if (restingHR >= 68) {return "Above Average";}
		else if (restingHR >= 64) {return "Good";}
		else if (restingHR >= 58) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRMale56to65(restingHR) {
		if      (restingHR >= 82) {return "Poor";}
		else if (restingHR >= 76) {return "Below Average";}
		else if (restingHR >= 72) {return "Average";}
		else if (restingHR >= 68) {return "Above Average";}
		else if (restingHR >= 62) {return "Good";}
		else if (restingHR >= 57) {return "Excellent";}
		else {return "Athlete";}
	}
	
	function getAssessmentForRestingHRMaleAbove65(restingHR) {
		if      (restingHR >= 80) {return "Poor";}
		else if (restingHR >= 74) {return "Below Average";}
		else if (restingHR >= 70) {return "Average";}
		else if (restingHR >= 66) {return "Above Average";}
		else if (restingHR >= 62) {return "Good";}
		else if (restingHR >= 56) {return "Excellent";}
		else {return "Athlete";}
	}
	
}