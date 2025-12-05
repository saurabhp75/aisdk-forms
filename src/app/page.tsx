import { v7 as uuidv7 } from "uuid";
import Chat from "./chat/[chatId]/chat";

export default async function ChatPage() {
  return <Chat chatData={{ id: uuidv7(), messages: [] }} isNewChat />;
}
