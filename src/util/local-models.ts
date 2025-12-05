import type { LanguageModel } from "ai";
import { ollama } from "ollama-ai-provider-v2";

export const ollamaDeepSeek = ollama(
  "deepseek-r1:8b",
) as unknown as LanguageModel;
export const ollamaLlama = ollama(
  "llama3.1:latest",
) as unknown as LanguageModel;
export const ollamaQwen3 = ollama("qwen3:4b") as unknown as LanguageModel;
export const ollamaQwen3VL = ollama("qwen3-vl:4b") as unknown as LanguageModel;
export const ollamaGranite = ollama("granite4:3b") as unknown as LanguageModel;
