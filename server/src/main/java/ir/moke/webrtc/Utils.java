package ir.moke.webrtc;

import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;

import java.util.Random;

public class Utils {

    private static final Jsonb jsonb = JsonbBuilder.create();

    public static String randomString(int stringLength) {
        int leftLimit = 97; // letter 'a'
        int rightLimit = 122; // letter 'z'
        Random random = new Random();

        return random.ints(leftLimit, rightLimit + 1)
                .limit(stringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }

    public static String toJson(Object o) {
        return jsonb.toJson(o);
    }

    public static <T> T fromJson(String str, Class<T> type) {
        return jsonb.fromJson(str, type);
    }
}
