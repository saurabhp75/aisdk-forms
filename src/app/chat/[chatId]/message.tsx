"use client";

import type { ChatStatus } from "ai";
import { useEffect, useState } from "react";
import type { MyUIMessage } from "@/util/chat-schema";

export default function Message({
  message,
  status,
  regenerate,
  sendMessage,
}: {
  status: ChatStatus;
  message: MyUIMessage;
  regenerate: ({ messageId }: { messageId: string }) => void;
  sendMessage: ({
    text,
    messageId,
  }: {
    text: string;
    messageId?: string;
  }) => void;
}) {
  const [date, setDate] = useState<string>("");

  useEffect(() => {
    if (message.metadata?.createdAt) {
      setDate(new Date(message.metadata.createdAt).toLocaleString());
    }
  }, [message.metadata?.createdAt]);

  const isUser = message.role === "user";

  return (
    <div
      className={`whitespace-pre-wrap my-2 p-3 rounded-lg shadow text-gray-800
        ${isUser ? "bg-blue-100 text-right ml-10" : "bg-gray-100 text-left mr-10"}`}
    >
      <div className="mb-1 text-xs text-gray-500">{date}</div>
      <div className="font-semibold">{isUser ? "User:" : "AI:"}</div>
      <div>
        {message.parts
          .map((part) => (part.type === "text" ? part.text : ""))
          .join("")}
      </div>
      {message.role === "user" && (
        <>
          <button
            type="button"
            onClick={() => regenerate({ messageId: message.id })}
            className="px-3 py-1 mt-2 text-sm transition-colors bg-gray-200 rounded-md hover:bg-gray-300"
            disabled={status !== "ready"}
          >
            Regenerate
          </button>
          <button
            type="button"
            onClick={() =>
              sendMessage({ text: "Hello", messageId: message.id })
            }
            className="px-3 py-1 mt-2 text-sm transition-colors bg-gray-200 rounded-md hover:bg-gray-300"
            disabled={status !== "ready"}
          >
            Replace with Hello
          </button>
        </>
      )}
    </div>
  );
}
