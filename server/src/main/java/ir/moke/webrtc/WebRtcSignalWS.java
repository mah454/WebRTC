package ir.moke.webrtc;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@ApplicationScoped
@ServerEndpoint("/webrtc/signal/")
public class WebRtcSignalWS {
    private static final Logger LOGGER = LoggerFactory.getLogger(WebRtcSignalWS.class.getName());
    private static final List<Session> SESSION_LIST = new ArrayList<>();

    @OnOpen
    public void onOpen(Session session) {
        if (!SESSION_LIST.contains(session)) {
            LOGGER.info("New session opened: " + session.getId());
            SESSION_LIST.add(session);
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject jsonObject = Utils.fromJson(message, JsonObject.class);
            String type = jsonObject.getString("type");
            LOGGER.info(String.format("Receive message from:%s  type:%s", session.getId(),type));
            if (type.equals("join")) {
                JsonObject joinedJson = Json.createObjectBuilder().add("type", "joined").build();
                broadcastMessage(joinedJson.toString(), session);
            } else {
                broadcastMessage(message, session);
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
            e.printStackTrace();
        }
    }

    private static void broadcastMessage(String message, Session session) {
        SESSION_LIST.stream()
                .filter(item -> !item.equals(session))
                .forEach(item -> item.getAsyncRemote().sendText(message));
    }

    @OnClose
    public void onClose(Session session) throws IOException {
        LOGGER.info("Session closes: " + session.getId());
        SESSION_LIST.remove(session);
    }
}