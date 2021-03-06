package org.dbcli;

import sun.misc.Signal;
import sun.misc.SignalHandler;

import java.awt.event.ActionEvent;
import java.util.HashMap;

public class Interrupter {
    static HashMap<Object, EventCallback> map = new HashMap<>();

    static {
        Signal.handle(new Signal("INT"), new SignalHandler() {
            @Override
            public void handle(Signal signal) {
                if (!map.isEmpty()) {
                    ActionEvent e = new ActionEvent(this, ActionEvent.ACTION_PERFORMED, "\3");
                    for (EventCallback c : map.values()) {
                        //System.out.println(c.toString());
                        try {
                            c.interrupt(e);
                        } catch (StackOverflowError e1) {
                            return;
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                }
                //this.handle(signal);
            }
        });
    }

    public static void listen(Object name, EventCallback c) {
        //System.out.println(name.toString()+(c==null?"null":c.toString()));
        if (map.containsKey(name)) map.remove(name);
        if (c != null) map.put(name, c);
    }
}