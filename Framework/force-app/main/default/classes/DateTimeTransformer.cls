public class DateTimeTransformer {

    // Inner class to hold output parameters
    public class Response {
        @InvocableVariable(label='Formatted DateTime' description='Formatted CreatedDate in specified format')
        public String formattedDateTimeOutput;
    }

    @InvocableMethod(label='Transform DateTime' description='Transforms input DateTime to UTC-5 and formats it')
    public static List<Response> transformDateTime(List<DateTime> dateTimes) {
        List<Response> responses = new List<Response>();

        for (DateTime dt : dateTimes) {        

            // Subtract 5 hours from UTC time
            DateTime utcMinus5 = dt.addHours(-5);

            // Extract components           
            Integer year = utcMinus5.yearGmt();
            Integer month = utcMinus5.monthGmt();
            Integer day = utcMinus5.dayGmt();
            Integer hour = utcMinus5.hourGmt();
            Integer minute = utcMinus5.minuteGmt();
            Integer second = utcMinus5.secondGmt();
            
            // Pad single-digit values with leading zero
            String formattedYear = String.valueOf(year);
            String formattedMonth = month < 10 ? '0' + month : String.valueOf(month);
            String formattedDay = day < 10 ? '0' + day : String.valueOf(day);
            String formattedHour = hour < 10 ? '0' + hour : String.valueOf(hour);
            String formattedMinute = minute < 10 ? '0' + minute : String.valueOf(minute);
            String formattedSecond = second < 10 ? '0' + second : String.valueOf(second);           

            // Create the concatenated string
            String formattedDateTime = formattedYear + '-' + formattedMonth + '-' + formattedDay + 
                                        'T' + formattedHour + ':' + formattedMinute + ':' + formattedSecond + 
                                        '-05:00';         
            
            // Create response object
            Response res = new Response();
            res.formattedDateTimeOutput = formattedDateTime;
            responses.add(res);
        }
        
        return responses;
    }

}